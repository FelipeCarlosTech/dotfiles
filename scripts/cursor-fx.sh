#!/usr/bin/env bash
# cursor-fx.sh — cambia el efecto de cursor de Ghostty (shaders en effects/)
# Uso:
#   cfx              -> lista efectos y muestra el activo
#   cfx <n|nombre>   -> activa ese efecto (p.ej. cfx 3  /  cfx bloom)
#
# El efecto elegido se guarda en .cursor-fx; el shader en sí lo genera
# scripts/theme.sh, que lo tinta con el accent del tema activo. Así el cursor
# nunca se desincroniza del resto del tema.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd -P)"

EFFECTS="$DOTFILES_DIR/ghostty/shaders/effects"
FX_MARKER="$DOTFILES_DIR/.cursor-fx"
THEME_SH="$SCRIPT_DIR/theme.sh"
DEFAULT_FX="9-smearbreathe"

current() {
  if [ -f "$FX_MARKER" ]; then
    tr -d '[:space:]' <"$FX_MARKER"
  else
    echo "$DEFAULT_FX"
  fi
}

usage() {
  echo "🎯 Cursor FX para Ghostty"
  echo ""
  echo "Efectos disponibles:"
  for f in "$EFFECTS"/*.glsl; do
    b="$(basename "$f" .glsl)"
    echo "   ${b%%-*})  ${b#*-}"
  done
  echo ""
  echo "Activo: $(current)"
  echo ""
  echo "Uso:  cfx <número|nombre>   (ej: cfx 3  ó  cfx bloom)"
  echo "Luego pulsa  Cmd+Shift+,  en Ghostty para recargar."
}

if [ "$#" -eq 0 ] || [ "$1" = "list" ] || [ "$1" = "-l" ] || [ "$1" = "-h" ] || [ "$1" = "help" ]; then
  usage
  exit 0
fi

target=""
for f in "$EFFECTS"/*.glsl; do
  b="$(basename "$f" .glsl)" # ej: 3-bloom
  num="${b%%-*}"             # 3
  name="${b#*-}"             # bloom
  if [ "$1" = "$num" ] || [ "$1" = "$name" ] || [ "$1" = "$b" ]; then
    target="$b"
    break
  fi
done

if [ -z "$target" ]; then
  echo "❌ Efecto no encontrado: '$1'" >&2
  echo ""
  usage
  exit 1
fi

printf '%s\n' "$target" >"$FX_MARKER"

# Regenera active_cursor.glsl tintado con el accent del tema activo.
"$THEME_SH" --shader-only

echo "✅ Cursor FX activado: $target"
echo "👉 Pulsa  Cmd+Shift+,  en Ghostty para recargar la config."
