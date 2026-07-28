#!/usr/bin/env bash
# Script de mantenimiento para dotfiles

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd -P)"

case "$1" in
"status")
  echo "🔍 Estado de symlinks:"
  echo ""

  # Verificar cada symlink
  check_symlink() {
    local target="$1"
    local name="$2"

    if [ -L "$target" ]; then
      local link_target
      link_target="$(readlink "$target")"
      if [[ "$link_target" == "$DOTFILES_DIR"* ]]; then
        echo "✅ $name: $target -> $link_target"
      else
        echo "⚠️  $name: $target -> $link_target (NO apunta a dotfiles)"
      fi
    elif [ -e "$target" ]; then
      echo "❌ $name: $target (archivo regular, NO es symlink)"
    else
      echo "❓ $name: $target (no existe)"
    fi
  }

  check_symlink "$HOME/.bashrc" "Bash"
  check_symlink "$HOME/.config/ghostty" "Ghostty"
  check_symlink "$HOME/.config/nvim" "Neovim"
  check_symlink "$HOME/.config/starship.toml" "Starship"

  echo ""
  echo "🎨 Estado del tema:"
  if [ -f "$DOTFILES_DIR/.theme" ]; then
    echo "✅ Tema activo: $(tr -d '[:space:]' <"$DOTFILES_DIR/.theme")"
  else
    echo "❓ Ningún tema aplicado todavía (corré ./scripts/theme.sh <nombre>)"
  fi
  if [ -f "$DOTFILES_DIR/.cursor-fx" ]; then
    echo "✅ Cursor FX: $(tr -d '[:space:]' <"$DOTFILES_DIR/.cursor-fx")"
  fi

  # Artefactos generados: si falta alguno, el tema está a medio aplicar.
  echo ""
  echo "🧩 Artefactos generados:"
  for artifact in \
    "ghostty/theme.conf" \
    "ghostty/shaders/active_cursor.glsl" \
    "nvim/lua/config/theme.lua"; do
    if [ -f "$DOTFILES_DIR/$artifact" ]; then
      echo "✅ $artifact"
    else
      echo "❌ $artifact (falta — corré ./scripts/theme.sh --reapply)"
    fi
  done
  ;;

"git-status")
  echo "📊 Estado del repositorio:"
  cd "$DOTFILES_DIR" || exit 1
  git status --short
  echo ""
  echo "📝 Commits recientes:"
  git log --oneline -5
  ;;

"backup")
  echo "💾 Creando backup de configuraciones actuales..."
  BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$BACKUP_DIR"

  # Backup de archivos/directorios que no sean symlinks
  for path in ~/.bashrc ~/.config/ghostty ~/.config/nvim ~/.config/starship.toml; do
    if [ -e "$path" ] && [ ! -L "$path" ]; then
      cp -r "$path" "$BACKUP_DIR/"
      echo "📋 Backup: $path"
    fi
  done

  echo "✅ Backup creado en: $BACKUP_DIR"
  ;;

*)
  echo "🔧 Script de mantenimiento dotfiles"
  echo ""
  echo "Uso: ./scripts/sync.sh [comando]"
  echo ""
  echo "Comandos:"
  echo "  status      - Verificar symlinks, tema activo y artefactos generados"
  echo "  git-status  - Ver estado del repositorio git"
  echo "  backup      - Crear backup de configs actuales"
  echo ""
  echo "Ejemplos:"
  echo "  ./scripts/sync.sh status"
  echo "  ./scripts/sync.sh git-status"
  ;;
esac
