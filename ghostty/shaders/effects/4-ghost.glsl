// 4-ghost — afterimage: deja una copia del cursor en la posición anterior que se desvanece
vec2 N(vec2 v, float p) { return (v * 2.0 - iResolution.xy * p) / iResolution.y; }
float sdBox(vec2 p, vec2 c, vec2 b) { vec2 d = abs(p - c) - b; return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0); }

const vec3 COL = vec3(1.0, 0.706, 0.329); // @theme:accent
const float DURATION = 0.45;              // cuánto tarda en desvanecerse el fantasma

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord.xy / iResolution.xy);
    vec2 vu = N(fragCoord, 1.0);

    vec4 prev = vec4(N(iPreviousCursor.xy, 1.0), N(iPreviousCursor.zw, 0.0));
    vec2 pc = vec2(prev.x + prev.z * 0.5, prev.y - prev.w * 0.5);
    vec2 phb = prev.zw * 0.5;

    float t = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    float d = sdBox(vu, pc, phb);
    float box = smoothstep(0.004, 0.0, d); // dentro de la caja anterior
    float alpha = (1.0 - t) * 0.6;          // se desvanece con el tiempo

    fragColor = mix(base, base + vec4(COL, 0.0), box * alpha);
}
