#!/usr/bin/env bash
# ghostty-cross.sh — arma 4 paneles en cruz (2x2) en la ventana actual de Ghostty.
#
# Ghostty mapea un keybind a UNA sola acción y no tiene archivos de layout, así
# que una cruz con un solo atajo es imposible de forma nativa. Este script manda
# las mismas cuatro pulsaciones vía System Events:
#
#   cmd+d        split a la derecha      →  | |
#   cmd+shift+d  split abajo (derecha)   →  | ⌐
#   cmd+alt+h    foco a la izquierda
#   cmd+shift+d  split abajo (izquierda) →  ⌐ ⌐
#   cmd+ctrl+r   iguala tamaños
#
# Requiere permiso de Accesibilidad para quien lo ejecute (Ajustes del Sistema →
# Privacidad y seguridad → Accesibilidad). Sin ese permiso macOS descarta las
# pulsaciones en silencio, así que lo chequeamos antes y explicamos.
#
# Uso: cross [DELAY]     DELAY por defecto: 0.25s entre pulsaciones.
set -euo pipefail

DELAY="${1:-0.25}"

if ! osascript -e 'tell application "System Events" to get name of first process' >/dev/null 2>&1; then
  echo "❌ Sin permiso de Accesibilidad — macOS bloquea las pulsaciones sintéticas." >&2
  echo "   Dáselo en: Ajustes del Sistema → Privacidad y seguridad → Accesibilidad" >&2
  echo "   (agregá la app que corre este comando, p.ej. Ghostty)" >&2
  echo "" >&2
  echo "   O simplemente pulsá estos cuatro atajos a mano:" >&2
  echo "     cmd+d  →  cmd+shift+d  →  cmd+alt+h  →  cmd+shift+d  →  cmd+ctrl+r" >&2
  exit 1
fi

osascript \
  -e 'on run argv' \
  -e '  set d to (item 1 of argv) as real' \
  -e '  tell application "Ghostty" to activate' \
  -e '  delay d' \
  -e '  tell application "System Events"' \
  -e '    keystroke "d" using {command down}' \
  -e '    delay d' \
  -e '    keystroke "d" using {command down, shift down}' \
  -e '    delay d' \
  -e '    keystroke "h" using {command down, option down}' \
  -e '    delay d' \
  -e '    keystroke "d" using {command down, shift down}' \
  -e '    delay d' \
  -e '    keystroke "r" using {command down, control down}' \
  -e '  end tell' \
  -e 'end run' \
  "$DELAY"

echo "✅ Layout en cruz (2x2) creado."
