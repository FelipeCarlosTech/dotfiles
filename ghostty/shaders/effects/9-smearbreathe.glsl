// 9-smearbreathe — smear al escribir/mover + blink y breathe SINCRONIZADOS al estar quieto.
// El blink del bloque y el latido del halo salen del MISMO reloj (sin(iTime*BLINK_SPEED)),
// así van siempre a la misma velocidad y en fase. Pon cursor-style-blink = false en el config
// (este shader genera su propio blink).
float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b) {
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}
float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    float segd = dot(p - proj, p - proj);
    d = min(d, segd);
    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float allCond = c0 * c1 * c2;
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    s *= flip;
    return d;
}
float getSdfParallelogram(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3) {
    float s = 1.0;
    float d = dot(p - v0, p - v0);
    d = seg(p, v0, v3, s, d);
    d = seg(p, v1, v0, s, d);
    d = seg(p, v2, v1, s, d);
    d = seg(p, v3, v2, s, d);
    return s * sqrt(d);
}
vec2 norm(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}
float antialising(float distance) {
    return 1.0 - smoothstep(0.0, norm(vec2(2.0, 2.0), 0.0).x, distance);
}
float determineStartVertexFactor(vec2 a, vec2 b) {
    float condition1 = step(b.x, a.x) * step(a.y, b.y);
    float condition2 = step(a.x, b.x) * step(b.y, a.y);
    return 1.0 - max(condition1, condition2);
}
vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + (rectangle.z / 2.0), rectangle.y - (rectangle.w / 2.0));
}
float ease(float x) { return pow(1.0 - x, 3.0); }

// ---- Ajustes -------------------------------------------------------
const float OPACITY      = 0.6;    // intensidad del smear
const float DURATION     = 0.18;   // duración del smear al moverse
const vec3  ACCENT        = vec3(1.0, 0.706, 0.329); // @theme:accent
const vec3  BG           = vec3(0.0392, 0.0549, 0.0784); // @theme:bg
const float SETTLE       = 0.35;   // s que tarda en empezar el blink/breathe tras moverse
const float BLINK_SPEED  = 4.4;    // velocidad del blink+breathe (un poco más lento, ~1.43s periodo)
const float BREATHE_GLOW = 0.05;   // brillo del halo (casi imperceptible)
// -------------------------------------------------------------------

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    vec2 vu = norm(fragCoord, 1.0);
    vec2 offsetFactor = vec2(-0.5, 0.5);

    vec4 currentCursor = vec4(norm(iCurrentCursor.xy, 1.0), norm(iCurrentCursor.zw, 0.0));
    vec4 previousCursor = vec4(norm(iPreviousCursor.xy, 1.0), norm(iPreviousCursor.zw, 0.0));

    float vertexFactor = determineStartVertexFactor(currentCursor.xy, previousCursor.xy);
    float invertedVertexFactor = 1.0 - vertexFactor;

    vec2 v0 = vec2(currentCursor.x + currentCursor.z * vertexFactor, currentCursor.y - currentCursor.w);
    vec2 v1 = vec2(currentCursor.x + currentCursor.z * invertedVertexFactor, currentCursor.y);
    vec2 v2 = vec2(previousCursor.x + currentCursor.z * invertedVertexFactor, previousCursor.y);
    vec2 v3 = vec2(previousCursor.x + currentCursor.z * vertexFactor, previousCursor.y - previousCursor.w);

    float sdfCurrentCursor = getSdfRectangle(vu, currentCursor.xy - (currentCursor.zw * offsetFactor), currentCursor.zw * 0.5);
    float sdfTrail = getSdfParallelogram(vu, v0, v1, v2, v3);

    float progress = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    float easedProgress = ease(progress);
    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);
    float lineLength = distance(centerCC, centerCP);

    // --- SMEAR (al escribir / moverse) ---
    vec4 newColor = vec4(fragColor);
    newColor = mix(newColor, vec4(ACCENT, 1.0), antialising(sdfTrail));
    newColor = mix(newColor, vec4(ACCENT, 1.0), antialising(sdfCurrentCursor));
    newColor = mix(newColor, fragColor, step(sdfCurrentCursor, 0.0));
    newColor = mix(fragColor, newColor, OPACITY);
    fragColor = mix(fragColor, newColor, step(sdfCurrentCursor, easedProgress * lineLength));

    // --- BLINK + BREATHE sincronizados (solo en reposo) ---
    float idle = clamp((iTime - iTimeCursorChange) / SETTLE, 0.0, 1.0); // 0 al moverse -> 1 quieto
    float s = sin(iTime * BLINK_SPEED);
    float insideBox = step(sdfCurrentCursor, 0.0);

    // Blink del bloque: onda cuadrada; oculta el bloque (pinta fondo) en la fase "off"
    float blinkOff = (1.0 - step(0.0, s)) * idle;
    fragColor.rgb = mix(fragColor.rgb, BG, insideBox * blinkOff);

    // Breathe del halo: mismo reloj -> pico cuando el bloque está "on"; brillo bajo
    float pulse = 0.5 + 0.5 * s;
    float halo = exp(-max(sdfCurrentCursor, 0.0) / 0.045) * step(0.0, sdfCurrentCursor);
    fragColor.rgb += ACCENT * halo * pulse * BREATHE_GLOW * idle;
}
