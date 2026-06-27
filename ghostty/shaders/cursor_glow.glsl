// Cursor Glow / Pulse — efecto de halo que "late" alrededor del cursor.
// Pensado para encadenarse DESPUÉS de cursor_trail.glsl en Ghostty:
//   custom-shader = shaders/cursor_trail.glsl
//   custom-shader = shaders/cursor_glow.glsl
// Requiere: custom-shader-animation = always  (para que el pulso anime).

float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b) {
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// Misma normalización a espacio -1..1 que usa cursor_trail.glsl
vec2 normCoord(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

// ---- Ajustes (toca estos para tunear el efecto) -------------------
const vec3  GLOW_COLOR    = vec3(1.0, 0.706, 0.329); // Ayu Dark ámbar (#FFB454)
const float GLOW_RADIUS   = 0.05;  // tamaño del halo (mayor = más grande)
const float GLOW_STRENGTH = 0.55;  // intensidad máxima del halo
const float PULSE_SPEED   = 4.0;   // velocidad del latido
const float PULSE_MIN     = 0.45;  // brillo mínimo del pulso (0..1)
// -------------------------------------------------------------------

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord.xy / iResolution.xy);

    vec2 vu = normCoord(fragCoord, 1.0);

    // Posición y tamaño del cursor en espacio normalizado
    vec4 cursor = vec4(normCoord(iCurrentCursor.xy, 1.0), normCoord(iCurrentCursor.zw, 0.0));
    vec2 offsetFactor = vec2(-0.5, 0.5);
    vec2 center = cursor.xy - (cursor.zw * offsetFactor);

    // Distancia (con signo) al rectángulo del cursor
    float d = getSdfRectangle(vu, center, cursor.zw * 0.5);

    // Pulso suave: oscila entre PULSE_MIN y 1.0
    float pulse = mix(PULSE_MIN, 1.0, 0.5 + 0.5 * sin(iTime * PULSE_SPEED));

    // Halo: intenso pegado al borde del cursor, se desvanece hacia afuera.
    float glow = exp(-max(d, 0.0) / GLOW_RADIUS) * GLOW_STRENGTH * pulse;

    // Solo fuera del bloque (d > 0); dentro el cursor queda intacto.
    glow *= step(0.0, d);

    fragColor = base + vec4(GLOW_COLOR * glow, 0.0);
}
