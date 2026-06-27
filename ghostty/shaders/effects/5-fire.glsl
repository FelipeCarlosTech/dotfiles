// 5-fire — llama parpadeante que sube desde el cursor
vec2 N(vec2 v, float p) { return (v * 2.0 - iResolution.xy * p) / iResolution.y; }
float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord.xy / iResolution.xy);
    vec2 vu = N(fragCoord, 1.0);

    vec4 cur = vec4(N(iCurrentCursor.xy, 1.0), N(iCurrentCursor.zw, 0.0));
    vec2 cc = vec2(cur.x + cur.z * 0.5, cur.y - cur.w * 0.5);
    vec2 hb = cur.zw * 0.5;

    vec2 p = vu - cc;                 // posición relativa al cursor
    float up = max(p.y, 0.0);          // por encima del centro = llama
    float colMask = smoothstep(hb.x * 1.8, 0.0, abs(p.x)); // ancho ~ cursor
    float flicker = hash(vec2(floor(vu.x * 60.0), floor(iTime * 16.0)));
    float flame = smoothstep(0.14, 0.0, up) * colMask * (0.55 + 0.45 * flicker);

    // gradiente: amarillo en la base -> rojo en la punta
    vec3 fireCol = mix(vec3(1.0, 0.9, 0.3), vec3(1.0, 0.2, 0.0), clamp(up / 0.14, 0.0, 1.0));

    fragColor = base + vec4(fireCol * flame * 0.9, 0.0);
}
