#!/bin/bash
# Dotfiles installation script for macOS

set -e

DOTFILES_DIR="$HOME/code/felipecarlos/dotfiles"

echo "🍎 Installing dotfiles for macOS..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create symlink function
create_symlink() {
  local source="$1"
  local target="$2"
  local name="$(basename "$target")"

  echo "→ $name"

  # Check source exists
  if [ ! -e "$source" ]; then
    echo "  ✗ Source not found: $source"
    return 1
  fi

  # Create parent directory
  mkdir -p "$(dirname "$target")"

  # Handle existing file/directory
  if [ -e "$target" ]; then
    if [ -L "$target" ]; then
      # Existing symlink
      if [ "$(readlink "$target")" = "$source" ]; then
        echo "  ✓ Already configured"
        return 0
      fi
      rm "$target"
    else
      # Real file/directory - backup
      local backup="$target.backup.$(date +%Y%m%d-%H%M%S)"
      mv "$target" "$backup"
      echo "  ✓ Backed up to: $backup"
    fi
  fi

  # Create symlink
  ln -sf "$source" "$target"
  echo "  ✓ Symlink created"
}

# Install Homebrew if needed
if ! command -v brew >/dev/null 2>&1; then
  echo "📦 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  echo ""
fi

# Install all required applications and tools
echo "🔧 Installing applications and tools..."
brew install --cask alacritty ghostty 2>/dev/null || true
brew install zellij neovim zoxide fzf starship 2>/dev/null || true
echo ""

# Create symlinks
echo "🔗 Creating symlinks..."
create_symlink "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty"
create_symlink "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
create_symlink "$DOTFILES_DIR/zellij" "$HOME/.config/zellij"
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
create_symlink "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
echo ""

# Configure FZF keybindings
if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
  echo "⌨️  Configuring FZF..."
  "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash 2>/dev/null || true
  echo ""
fi

# Success message
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Installation complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Install font manually:"
echo "      brew tap homebrew/cask-fonts"
echo "      brew install font-google-sans-code-nerd-font"
echo "   2. Restart your terminal"
echo "   3. Open Neovim - plugins will auto-install"
echo ""
echo "💡 Quick tips:"
echo "   • Edit files in $DOTFILES_DIR - changes apply instantly"
echo "   • Ctrl+g in terminal to unlock Zellij"
echo "   • z <dir> to jump with zoxide"
echo "   • Ctrl+R for FZF history search"
echo ""
