#!/bin/bash
# Script instalación dotfiles macOS con symlinks bidireccionales

set -e

echo "🍎 Instalando dotfiles para macOS..."
echo "📂 Repo es fuente de verdad - cualquier cambio se aplica inmediatamente"

DOTFILES_DIR="$HOME/code/felipecarlos/dotfiles"

# Función para crear symlinks súper seguros
create_symlink() {
  local source="$1"
  local target="$2"

  echo "🔄 Procesando: $(basename "$target")"

  # Verificar que el source existe en dotfiles
  if [ ! -e "$source" ]; then
    echo "❌ Error: $source no existe en dotfiles"
    echo "💡 Tip: Crea el archivo primero: touch $source"
    return 1
  fi

  # Crear directorio padre si no existe
  local target_dir=$(dirname "$target")
  if [ ! -d "$target_dir" ]; then
    echo "📁 Creando directorio: $target_dir"
    mkdir -p "$target_dir"
  fi

  # Manejar archivo/directorio existente
  if [ -e "$target" ]; then
    if [ -L "$target" ]; then
      # Es un symlink existente
      local current_target=$(readlink "$target")
      if [ "$current_target" = "$source" ]; then
        echo "✅ Ya existe el symlink correcto"
        return 0
      else
        echo "🔄 Reemplazando symlink: $current_target -> $source"
        rm "$target"
      fi
    else
      # Es un archivo/directorio real - hacer backup
      local backup="$target.backup.$(date +%Y%m%d-%H%M%S)"
      echo "📋 Haciendo backup: $target -> $backup"
      mv "$target" "$backup"

      # Si es un directorio, ofrecer mergear contenido
      if [ -d "$backup" ] && [ -d "$source" ]; then
        echo "💡 Tip: Considera mergear contenido de $backup a $source si es necesario"
      fi
    fi
  fi

  # Crear nuevo symlink
  ln -sf "$source" "$target"
  echo "🔗 Symlink creado: $target -> $source"

  # Verificar que funcionó
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    echo "✅ Verificado correctamente"
  else
    echo "❌ Error: Symlink no se creó correctamente"
    return 1
  fi

  echo ""
}

# Crear symlinks (directorios completos)
create_symlink "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty"
create_symlink "$DOTFILES_DIR/zellij" "$HOME/.config/zellij"
create_symlink "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"

# LazyVim (symlink del directorio completo)
if [ -d "$DOTFILES_DIR/nvim" ]; then
  create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
fi

echo ""
echo "✅ Dotfiles instalados con symlinks!"
echo "🎯 Ahora puedes editar directamente en $DOTFILES_DIR/ y los cambios se aplican inmediatamente"
echo "📝 Workflow:"
echo "   1. Modifica $DOTFILES_DIR/alacritty/alacritty.toml"
echo "   2. Agrega temas en $DOTFILES_DIR/alacritty/themes/"
echo "   3. Crea layouts en $DOTFILES_DIR/zellij/layouts/"
echo "   4. Los cambios se ven inmediatamente en el sistema"
echo "   5. git add . && git commit -m 'Update config'"
echo "   6. git push"
echo ""
echo "🔄 Reinicia tu terminal"
