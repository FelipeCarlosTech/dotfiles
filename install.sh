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
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

# LazyVim (symlink del directorio completo)
if [ -d "$DOTFILES_DIR/nvim" ]; then
  create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
fi

# Función para verificar si un comando existe
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Función para instalar plugins
install_plugins() {
  echo "🔌 Instalando plugins esenciales..."
  
  # Verificar si Homebrew está instalado
  if ! command_exists brew; then
    echo "⚠️  Homebrew no encontrado. Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Añadir Homebrew al PATH para la sesión actual
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  
  # Instalar zoxide
  if ! command_exists zoxide; then
    echo "📁 Instalando zoxide..."
    brew install zoxide
    if ! grep -q 'eval "$(zoxide init bash)"' "$HOME/.bashrc"; then
      echo 'eval "$(zoxide init bash)"' >> "$HOME/.bashrc"
      echo "✅ zoxide configurado en ~/.bashrc"
    fi
  else
    echo "✅ zoxide ya está instalado"
  fi
  
  # Instalar fzf
  if ! command_exists fzf; then
    echo "🔍 Instalando fzf..."
    brew install fzf
    # Instalar integraciones de teclado
    echo "🔧 Configurando integraciones de fzf..."
    "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc
    echo "✅ fzf instalado con integraciones"
  else
    echo "✅ fzf ya está instalado"
  fi
  
  # Instalar bash-preexec (requerido para atuin)
  if [ ! -f "$HOME/.bash-preexec.sh" ]; then
    echo "⚡ Instalando bash-preexec..."
    curl -s https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o "$HOME/.bash-preexec.sh"
    if ! grep -q 'source ~/.bash-preexec.sh' "$HOME/.bashrc"; then
      echo '[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh' >> "$HOME/.bashrc"
      echo "✅ bash-preexec configurado en ~/.bashrc"
    fi
  else
    echo "✅ bash-preexec ya está instalado"
  fi
  
  # Instalar atuin
  if ! command_exists atuin; then
    echo "📚 Instalando atuin..."
    brew install atuin
    if ! grep -q 'eval "$(atuin init bash)"' "$HOME/.bashrc"; then
      echo 'eval "$(atuin init bash)"' >> "$HOME/.bashrc"
      echo "✅ atuin configurado en ~/.bashrc"
    fi
  else
    echo "✅ atuin ya está instalado"
  fi
  
  echo ""
  echo "🎉 ¡Todos los plugins instalados correctamente!"
  echo "💡 Reinicia tu terminal para activar los plugins"
  echo "📋 Comandos útiles:"
  echo "   • z <directorio>     - Navegar con zoxide"
  echo "   • Ctrl+R            - Búsqueda de historial con atuin/fzf"
  echo "   • Ctrl+T            - Búsqueda de archivos con fzf"
  echo "   • atuin import      - Importar historial existente a atuin"
  echo ""
}

# Instalar plugins
install_plugins

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
echo "🔄 Reinicia tu terminal para activar todos los cambios"
