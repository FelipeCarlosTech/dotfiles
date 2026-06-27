// 3-bloom — resplandor neón intenso (doble capa) alrededor del cursor
vec2 N(vec2 v, float p) { return (v * 2.0 - iResolution.xy * p) / iResolution.y; }
float sdBox(vec2 p, vec2 c, vec2 b) { vec2 d = abs(p - c) - b; return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0); }

const vec3 COL = vec3(1.0, 0.706, 0.329); // Ayu ámbar (cambia a vec3(0.35,0.76,1.0) para neón cian)

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord.xy / iResolution.xy);
    vec2 vu = N(fragCoord, 1.0);

    vec4 cur = vec4(N(iCurrentCursor.xy, 1.0), N(iCurrentCursor.zw, 0.0));
    vec2 cc = vec2(cur.x + cur.z * 0.5, cur.y - cur.w * 0.5);
    vec2 hb = cur.zw * 0.5;

    float d = sdBox(vu, cc, hb);
    // dos capas: halo amplio + núcleo brillante
    float g = exp(-max(d, 0.0) / 0.10) * 0.7 + exp(-max(d, 0.0) / 0.03) * 1.2;
    g *= step(0.0, d); // solo fuera del bloque

    fragColor = base + vec4(COL * g, 0.0);
}
