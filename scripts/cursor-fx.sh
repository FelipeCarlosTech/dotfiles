#!/usr/bin/env bash
# cursor-fx.sh — cambia el efecto de cursor de Ghostty (shaders en effects/)
# Uso:
#   cfx              -> lista efectos y muestra el activo
#   cfx <n|nombre>   -> activa ese efecto (p.ej. cfx 3  /  cfx bloom)
set -euo pipefail

SHADERS="$HOME/.config/ghostty/shaders"
EFFECTS="$SHADERS/effects"
ACTIVE="$SHADERS/active_cursor.glsl"

current() {
  if [ -L "$ACTIVE" ]; then basename "$(readlink "$ACTIVE")" .glsl; else echo "(ninguno)"; fi
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
  b="$(basename "$f" .glsl)"   # ej: 3-bloom
  num="${b%%-*}"               # 3
  name="${b#*-}"               # bloom
  if [ "$1" = "$num" ] || [ "$1" = "$name" ] || [ "$1" = "$b" ]; then
    target="$f"
    break
  fi
done

if [ -z "$target" ]; then
  echo "❌ Efecto no encontrado: '$1'"
  echo ""
  usage
  exit 1
fi

ln -sf "effects/$(basename "$target")" "$ACTIVE"
echo "✅ Cursor FX activado: $(basename "$target" .glsl)"
echo "👉 Pulsa  Cmd+Shift+,  en Ghostty para recargar la config."
