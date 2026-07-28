#!/usr/bin/env bash
# Script para preparar dotfiles antes de hacer symlinks

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd -P)"

echo "🚀 Preparando dotfiles..."
echo "Este script copia tus configuraciones actuales al repo dotfiles"
echo ""

# Función para copiar configuración existente
copy_if_exists() {
  local source="$1"
  local dest="$2"
  local name="$3"

  if [ -e "$source" ] && [ ! -L "$source" ]; then
    echo "📋 Copiando $name: $source -> $dest"
    mkdir -p "$(dirname "$dest")"
    cp -r "$source" "$dest"
    echo "✅ $name copiado"
  elif [ -L "$source" ]; then
    echo "⚠️  $name ya es un symlink: $source -> $(readlink "$source")"
  else
    echo "💡 $name no existe, se usará configuración base"
    # Crear archivo base si no existe
    mkdir -p "$(dirname "$dest")"
    case "$name" in
    "Bash")
      cat >"$dest" <<'EOF'
# .bashrc personalizado
export HISTSIZE=1000
export HISTFILESIZE=2000
alias ll='ls -alF'
alias la='ls -A'
EOF
      ;;
    esac
    echo "✅ Configuración base de $name creada"
  fi
  echo ""
}

echo "🔍 Revisando configuraciones actuales..."
echo ""

# Copiar configuraciones existentes
copy_if_exists "$HOME/.bashrc" "$DOTFILES_DIR/bash/.bashrc" "Bash"

# Ghostty: se copia tal cual; los colores los regenera scripts/theme.sh después.
copy_if_exists "$HOME/.config/ghostty" "$DOTFILES_DIR/ghostty" "Ghostty"

# Neovim es especial - copiar todo el directorio
if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
  echo "📋 Copiando Neovim: ~/.config/nvim -> $DOTFILES_DIR/nvim"
  cp -r "$HOME/.config/nvim" "$DOTFILES_DIR/nvim"
  echo "✅ Neovim copiado"
elif [ -L "$HOME/.config/nvim" ]; then
  echo "⚠️  Neovim ya es un symlink: ~/.config/nvim -> $(readlink ~/.config/nvim)"
else
  echo "💡 Neovim no existe, se instalará LazyVim desde cero"
fi

echo ""
echo "✅ Preparación completada!"
echo ""
echo "📝 Siguiente paso:"
echo "   1. Revisa/edita los archivos en $DOTFILES_DIR/"
echo "   2. Ejecuta ./install.sh"
echo "   3. ¡Los cambios se aplicarán via symlinks!"
