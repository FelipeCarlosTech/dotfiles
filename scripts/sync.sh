#!/bin/bash
# Script de mantenimiento para dotfiles

DOTFILES_DIR="$HOME/code/felipecarlos/dotfiles"

case "$1" in
"status")
  echo "🔍 Estado de symlinks:"
  echo ""

  # Verificar cada symlink
  check_symlink() {
    local target="$1"
    local name="$2"

    if [ -L "$target" ]; then
      local link_target=$(readlink "$target")
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
  check_symlink "$HOME/.config/zellij" "Zellij"
  check_symlink "$HOME/.config/nvim" "Neovim"
  check_symlink "$HOME/.config/alacritty" "Alacritty"
  ;;

"git-status")
  echo "📊 Estado del repositorio:"
  cd "$DOTFILES_DIR"
  git status --short
  echo ""
  echo "📝 Commits pendientes:"
  git log --oneline -5
  ;;

"backup")
  echo "💾 Creando backup de configuraciones actuales..."
  BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$BACKUP_DIR"

  # Backup de archivos/directorios que no sean symlinks
  for path in ~/.bashrc ~/.config/alacritty ~/.config/zellij; do
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
  echo "  status      - Verificar estado de symlinks"
  echo "  git-status  - Ver estado del repositorio git"
  echo "  backup      - Crear backup de configs actuales"
  echo ""
  echo "Ejemplos:"
  echo "  ./scripts/sync.sh status"
  echo "  ./scripts/sync.sh git-status"
  ;;
esac
