// 7-breathe — parpadeo suave (respiración) del cursor en vez del titileo seco
// Recomendado: poner cursor-style-blink = false para no competir con el blink nativo.
vec2 N(vec2 v, float p) { return (v * 2.0 - iResolution.xy * p) / iResolution.y; }
float sdBox(vec2 p, vec2 c, vec2 b) { vec2 d = abs(p - c) - b; return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0); }

const vec3 COL = vec3(1.0, 0.706, 0.329); // @theme:accent

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord.xy / iResolution.xy);
    vec2 vu = N(fragCoord, 1.0);

    vec4 cur = vec4(N(iCurrentCursor.xy, 1.0), N(iCurrentCursor.zw, 0.0));
    vec2 cc = vec2(cur.x + cur.z * 0.5, cur.y - cur.w * 0.5);
    vec2 hb = cur.zw * 0.5;

    float d = sdBox(vu, cc, hb);
    float inside = smoothstep(0.003, 0.0, d);     // 1 dentro del bloque
    float pulse = 0.5 + 0.5 * sin(iTime * 3.0);    // respiración 0..1

    // el bloque late entre tenue y brillante
    vec3 breathColor = mix(COL * 0.25, COL, pulse);
    fragColor = mix(base, vec4(breathColor, 1.0), inside);

    // halo sutil que también respira
    float halo = exp(-max(d, 0.0) / 0.05) * step(0.0, d) * pulse * 0.3;
    fragColor += vec4(COL * halo, 0.0);
}
