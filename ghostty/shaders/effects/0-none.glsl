// 0-none — sin efecto (cursor nativo de Ghostty tal cual)
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
}
