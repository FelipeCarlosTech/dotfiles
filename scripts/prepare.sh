#!/bin/bash
# Script para preparar dotfiles antes de hacer symlinks

set -e

DOTFILES_DIR="$HOME/code/felipecarlos/dotfiles"

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
    "Alacritty")
      mkdir -p "$dest"
      cat >"$dest/alacritty.toml" <<'EOF'
[env]
TERM = "alacritty"

[window]
padding.x = 10
padding.y = 10

[font]
size = 12.0
EOF
      ;;
    "Zellij")
      mkdir -p "$dest/layouts"
      cat >"$dest/config.kdl" <<'EOF'
// Configuración base de Zellij
keybinds clear-defaults=true {
    normal {
        bind "Ctrl o" { SwitchToMode "tmux"; }
    }
}
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
copy_if_exists "$HOME/.config/alacritty" "$DOTFILES_DIR/alacritty" "Alacritty"
copy_if_exists "$HOME/.config/zellij" "$DOTFILES_DIR/zellij" "Zellij"

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
