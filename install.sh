#!/bin/bash
# Dotfiles installation script for macOS

set -e

DOTFILES_DIR="$HOME/code/dotfiles"

# Parse command line arguments
INSTALL_TERMINAL=""
while [[ $# -gt 0 ]]; do
  case $1 in
    --ghostty)
      INSTALL_TERMINAL="ghostty"
      shift
      ;;
    --alacritty)
      INSTALL_TERMINAL="alacritty"
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--ghostty|--alacritty]"
      echo "  --ghostty   Install only Ghostty terminal"
      echo "  --alacritty Install only Alacritty terminal"
      echo "  (no flag)   Install both terminals"
      exit 1
      ;;
  esac
done

echo "🍎 Installing dotfiles for macOS..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ -n "$INSTALL_TERMINAL" ]; then
  echo "Terminal: $INSTALL_TERMINAL only"
else
  echo "Terminal: Both Alacritty and Ghostty"
fi
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

# Install terminal emulator(s) based on flag
if [ -z "$INSTALL_TERMINAL" ]; then
  # No flag: install both
  brew install --cask alacritty ghostty 2>/dev/null || true
elif [ "$INSTALL_TERMINAL" = "ghostty" ]; then
  brew install --cask ghostty 2>/dev/null || true
elif [ "$INSTALL_TERMINAL" = "alacritty" ]; then
  brew install --cask alacritty 2>/dev/null || true
fi

# Install other tools
brew install zellij neovim zoxide fzf starship 2>/dev/null || true
echo ""

# Create symlinks
echo "🔗 Creating symlinks..."

# Create terminal symlinks based on flag
if [ -z "$INSTALL_TERMINAL" ]; then
  # No flag: create both
  create_symlink "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty"
  create_symlink "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
elif [ "$INSTALL_TERMINAL" = "ghostty" ]; then
  create_symlink "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
elif [ "$INSTALL_TERMINAL" = "alacritty" ]; then
  create_symlink "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty"
fi

# Create other symlinks
create_symlink "$DOTFILES_DIR/zellij" "$HOME/.config/zellij"
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
create_symlink "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"

# Create .bash_profile if it doesn't exist (needed for login shells)
if [ ! -f "$HOME/.bash_profile" ]; then
  echo "→ .bash_profile"
  cat > "$HOME/.bash_profile" << 'EOF'
if [[ -f ~/.bashrc ]]; then
  source ~/.bashrc
fi
EOF
  echo "  ✓ Created"
else
  echo "→ .bash_profile"
  echo "  ✓ Already exists"
fi
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
echo "   • Ctrl+R for fzf history search"
echo ""
