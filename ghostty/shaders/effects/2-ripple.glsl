// 2-ripple — onda que se expande desde el cursor al moverte
vec2 N(vec2 v, float p) { return (v * 2.0 - iResolution.xy * p) / iResolution.y; }

const vec3 COL = vec3(1.0, 0.706, 0.329); // Ayu ámbar #FFB454

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord.xy / iResolution.xy);
    vec2 vu = N(fragCoord, 1.0);

    vec4 cur = vec4(N(iCurrentCursor.xy, 1.0), N(iCurrentCursor.zw, 0.0));
    vec2 cc = vec2(cur.x + cur.z * 0.5, cur.y - cur.w * 0.5);

    float t = iTime - iTimeCursorChange;     // tiempo desde el último movimiento
    float r = t * 2.5;                        // radio que crece
    float d = abs(distance(vu, cc) - r);      // distancia al anillo
    float ring = smoothstep(0.025, 0.0, d);   // grosor del anillo
    float fade = 1.0 - clamp(r / 0.6, 0.0, 1.0); // se desvanece al expandir

    fragColor = base + vec4(COL * ring * fade * 0.9, 0.0);
}
