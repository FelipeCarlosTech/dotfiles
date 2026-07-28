#!/usr/bin/env bash
# theme.sh — aplica un tema en TODAS las herramientas desde una sola fuente de verdad.
#
# Uso:
#   theme                     lista los temas disponibles y muestra el activo
#   theme <nombre>            aplica ese tema en todo
#   theme --reapply           regenera los artefactos del tema activo
#
# Los temas viven en themes/*.sh. Agregar un tema = agregar UN archivo ahí
# (más su paleta en starship.toml y su plugin de colorscheme en nvim).
#
# Artefactos GENERADOS (nunca editar a mano):
#   ghostty/theme.conf                 incluido desde ghostty/config
#   ghostty/shaders/active_cursor.glsl shader del efecto, tintado con el accent
#   nvim/lua/config/theme.lua          nombres de colorscheme + lualine
# Parcheado en el lugar (una línea):
#   starship/starship.toml             la línea `palette = "..."`
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd -P)"

THEMES_DIR="$DOTFILES_DIR/themes"
THEME_MARKER="$DOTFILES_DIR/.theme"
FX_MARKER="$DOTFILES_DIR/.cursor-fx"
DEFAULT_FX="9-smearbreathe"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

die() {
  echo "❌ $*" >&2
  exit 1
}

# Tema activo, o vacío si todavía no se aplicó ninguno.
current_theme() {
  [ -f "$THEME_MARKER" ] && tr -d '[:space:]' <"$THEME_MARKER" || true
}

# Efecto de cursor activo (ver scripts/cursor-fx.sh).
current_fx() {
  if [ -f "$FX_MARKER" ]; then
    tr -d '[:space:]' <"$FX_MARKER"
  else
    echo "$DEFAULT_FX"
  fi
}

available_themes() {
  local f
  for f in "$THEMES_DIR"/*.sh; do
    [ -e "$f" ] || continue
    basename "$f" .sh
  done
}

# "#7aa2f7" -> "0.4784, 0.6353, 0.9686" (componentes de un vec3 GLSL)
hex_to_rgb() {
  local hex="${1#\#}"
  [ "${#hex}" -eq 6 ] || die "Color hex inválido: $1"
  local r=$((16#${hex:0:2})) g=$((16#${hex:2:2})) b=$((16#${hex:4:2}))
  awk -v r="$r" -v g="$g" -v b="$b" \
    'BEGIN { printf "%.4f, %.4f, %.4f", r / 255, g / 255, b / 255 }'
}

# Reemplaza la línea completa que matchea un regex. Falla fuerte si no matcheó
# nada, así una clave renombrada nunca deja un config silenciosamente en el
# tema viejo.
patch_line() {
  local file="$1" pattern="$2" replacement="$3"
  [ -f "$file" ] || die "No se puede parchear un archivo que no existe: $file"

  local tmp found=0 line
  tmp="$(mktemp)"
  while IFS= read -r line || [ -n "$line" ]; do
    if [[ $line =~ $pattern ]]; then
      printf '%s\n' "$replacement"
      found=1
    else
      printf '%s\n' "$line"
    fi
  done <"$file" >"$tmp"

  if [ "$found" -eq 0 ]; then
    rm -f "$tmp"
    die "Ninguna línea matchea /$pattern/ en $file"
  fi
  # Escribe a través de la ruta original para no romper los symlinks del repo.
  cat "$tmp" >"$file"
  rm -f "$tmp"
}

# Re-tinta una constante GLSL tageada, preservando el alpha de un vec4.
# Anclado al primer "=" para que un vecN mencionado en un comentario no moleste.
retint() {
  local line="$1" rgb="$2"
  if [[ $line =~ ^([^=]*=[[:space:]]*)vec4\([^\)]*\)(.*)$ ]]; then
    printf '%svec4(%s, 1.0)%s' "${BASH_REMATCH[1]}" "$rgb" "${BASH_REMATCH[2]}"
  elif [[ $line =~ ^([^=]*=[[:space:]]*)vec3\([^\)]*\)(.*)$ ]]; then
    printf '%svec3(%s)%s' "${BASH_REMATCH[1]}" "$rgb" "${BASH_REMATCH[2]}"
  else
    printf '%s' "$line"
  fi
}

# ---------------------------------------------------------------------------
# Generadores
# ---------------------------------------------------------------------------

generate_ghostty() {
  local out="$DOTFILES_DIR/ghostty/theme.conf"
  {
    echo "# GENERADO por scripts/theme.sh — no editar."
    echo "# Fuente de verdad: themes/$THEME_NAME.sh"
    echo "# Tema activo: $THEME_LABEL"
    echo ""
    if [ -n "$GHOSTTY_THEME" ]; then
      echo "# Tema built-in de Ghostty; los valores explícitos de abajo mantienen"
      echo "# la paleta idéntica incluso si el tema incluido cambiara."
      echo "theme = $GHOSTTY_THEME"
      echo ""
    fi
    echo "background = $BG"
    echo "foreground = $FG"
    echo "cursor-color = $CURSOR"
    echo "cursor-text = $CURSOR_TEXT"
    echo "selection-background = $SELECTION_BG"
    echo "selection-foreground = $SELECTION_FG"
    echo ""
    local i var
    for i in $(seq 0 15); do
      var="PALETTE_$i"
      echo "palette = $i=${!var}"
    done
  } >"$out"
  echo "   ✓ ghostty/theme.conf"
}

generate_shader() {
  local fx effect out accent_rgb bg_rgb line
  fx="$(current_fx)"
  effect="$DOTFILES_DIR/ghostty/shaders/effects/$fx.glsl"
  out="$DOTFILES_DIR/ghostty/shaders/active_cursor.glsl"

  if [ ! -f "$effect" ]; then
    echo "   ⚠ efecto de cursor '$fx' no encontrado — se omite el shader" >&2
    return 0
  fi

  accent_rgb="$(hex_to_rgb "$CURSOR")"
  bg_rgb="$(hex_to_rgb "$BG")"

  # En setups viejos active_cursor.glsl era un symlink: lo reemplazamos por un archivo.
  [ -L "$out" ] && rm -f "$out"

  {
    echo "// GENERADO por scripts/theme.sh — no editar."
    echo "// Efecto: $fx · Tema: $THEME_LABEL"
    echo "// Cambiá el efecto con \`cfx <n|nombre>\`, el tema con \`theme <nombre>\`."
    while IFS= read -r line || [ -n "$line" ]; do
      case "$line" in
        *"@theme:accent"*)
          retint "$line" "$accent_rgb"
          echo
          ;;
        *"@theme:bg"*)
          retint "$line" "$bg_rgb"
          echo
          ;;
        *) printf '%s\n' "$line" ;;
      esac
    done <"$effect"
  } >"$out"
  echo "   ✓ ghostty/shaders/active_cursor.glsl (efecto: $fx)"
}

generate_nvim() {
  local out="$DOTFILES_DIR/nvim/lua/config/theme.lua"
  cat >"$out" <<EOF
-- GENERADO por scripts/theme.sh -- no editar.
-- Fuente de verdad: themes/$THEME_NAME.sh
-- Tema activo: $THEME_LABEL
return {
  colorscheme = "$NVIM_COLORSCHEME",
  lualine = "$NVIM_LUALINE",
}
EOF
  echo "   ✓ nvim/lua/config/theme.lua"
}

patch_starship() {
  patch_line "$DOTFILES_DIR/starship/starship.toml" \
    '^palette = ' \
    "palette = \"$STARSHIP_PALETTE\""
  echo "   ✓ starship/starship.toml (paleta: $STARSHIP_PALETTE)"
}

# ---------------------------------------------------------------------------
# Comandos
# ---------------------------------------------------------------------------

load_theme() {
  local name="$1" file="$THEMES_DIR/$1.sh"
  [ -f "$file" ] || die "Tema desconocido: $name (corré \`theme\` para ver la lista)"

  # shellcheck disable=SC1090
  . "$file"
  THEME_NAME="$name"

  : "${THEME_LABEL:?themes/$name.sh debe definir THEME_LABEL}"
  : "${BG:?themes/$name.sh debe definir BG}"
  : "${FG:?themes/$name.sh debe definir FG}"
  : "${CURSOR:?themes/$name.sh debe definir CURSOR}"
  : "${CURSOR_TEXT:?themes/$name.sh debe definir CURSOR_TEXT}"
  : "${SELECTION_BG:?themes/$name.sh debe definir SELECTION_BG}"
  : "${SELECTION_FG:?themes/$name.sh debe definir SELECTION_FG}"
  : "${STARSHIP_PALETTE:?themes/$name.sh debe definir STARSHIP_PALETTE}"
  : "${NVIM_COLORSCHEME:?themes/$name.sh debe definir NVIM_COLORSCHEME}"
  : "${NVIM_LUALINE:?themes/$name.sh debe definir NVIM_LUALINE}"
  GHOSTTY_THEME="${GHOSTTY_THEME:-}"

  local i var
  for i in $(seq 0 15); do
    var="PALETTE_$i"
    [ -n "${!var:-}" ] || die "themes/$name.sh debe definir $var"
  done
}

usage() {
  local active t
  active="$(current_theme)"
  echo "🎨 Selector de tema"
  echo ""
  echo "Temas disponibles:"
  for t in $(available_themes); do
    if [ "$t" = "$active" ]; then
      echo "   → $t  (activo)"
    else
      echo "     $t"
    fi
  done
  echo ""
  echo "Efecto de cursor activo: $(current_fx)   (cambialo con \`cfx\`)"
  echo ""
  echo "Uso:  theme <nombre>   aplica un tema en todo"
  echo "      theme --reapply  regenera los artefactos del tema activo"
  echo ""
  echo "Después de cambiar, pulsá  Cmd+Shift+,  en Ghostty para recargar."
}

apply() {
  load_theme "$1"

  echo "🎨 Aplicando $THEME_LABEL"
  echo ""
  generate_ghostty
  generate_shader
  generate_nvim
  patch_starship

  printf '%s\n' "$THEME_NAME" >"$THEME_MARKER"

  echo ""
  echo "✅ $THEME_LABEL aplicado."
  echo ""
  echo "👉 Para verlo:"
  echo "   • Ghostty:  Cmd+Shift+,  para recargar"
  echo "   • Bash:     source ~/.bashrc  (o abrí una shell nueva)"
  echo "   • Neovim:   reiniciá"
}

main() {
  local active
  case "${1:-}" in
    "" | list | -l | -h | help | --help)
      usage
      ;;
    --reapply)
      active="$(current_theme)"
      [ -n "$active" ] || die "Todavía no hay tema activo — corré \`theme <nombre>\` primero."
      apply "$active"
      ;;
    --shader-only)
      # Lo usa scripts/cursor-fx.sh para que la generación del shader viva en un solo lugar.
      active="$(current_theme)"
      [ -n "$active" ] || die "Todavía no hay tema activo — corré \`theme <nombre>\` primero."
      load_theme "$active"
      generate_shader
      ;;
    *)
      apply "$1"
      ;;
  esac
}

main "$@"
