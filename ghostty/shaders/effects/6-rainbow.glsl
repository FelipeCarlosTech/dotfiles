// 6-rainbow — halo que cicla colores (arcoíris) alrededor del cursor
vec2 N(vec2 v, float p) { return (v * 2.0 - iResolution.xy * p) / iResolution.y; }
float sdBox(vec2 p, vec2 c, vec2 b) { vec2 d = abs(p - c) - b; return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0); }
vec3 hsv2rgb(vec3 c) {
    vec3 p = abs(fract(c.xxx + vec3(0.0, 2.0/3.0, 1.0/3.0)) * 6.0 - 3.0);
    return c.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), c.y);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord.xy / iResolution.xy);
    vec2 vu = N(fragCoord, 1.0);

    vec4 cur = vec4(N(iCurrentCursor.xy, 1.0), N(iCurrentCursor.zw, 0.0));
    vec2 cc = vec2(cur.x + cur.z * 0.5, cur.y - cur.w * 0.5);
    vec2 hb = cur.zw * 0.5;

    float d = sdBox(vu, cc, hb);
    float g = exp(-max(d, 0.0) / 0.06) * step(0.0, d);
    float hue = fract(iTime * 0.15 + distance(vu, cc) * 0.5); // gira en tiempo y espacio
    vec3 col = hsv2rgb(vec3(hue, 0.85, 1.0));

    fragColor = base + vec4(col * g * 0.7, 0.0);
}
