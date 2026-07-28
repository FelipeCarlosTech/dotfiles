#!/usr/bin/env bash
# Dotfiles installation script for macOS
#
# Usage:
#   ./install.sh                        install and apply the committed theme
#   ./install.sh --theme <name>         install and apply a specific theme
#
# Available themes: see themes/*.sh (or run ./scripts/theme.sh)

set -e

# Resolve the repo from this script's own location, so the install works from
# any clone path. (Hardcoding it broke every fresh machine that cloned elsewhere.)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

THEME_ARG=""
while [[ $# -gt 0 ]]; do
  case $1 in
    --theme)
      THEME_ARG="${2:-}"
      if [ -z "$THEME_ARG" ]; then
        echo "❌ --theme requires a name (see themes/*.sh)"
        exit 1
      fi
      shift 2
      ;;
    -h | --help)
      echo "Usage: $0 [--theme <name>]"
      echo "  --theme <name>  Apply this theme after install (see themes/*.sh)"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--theme <name>]"
      exit 1
      ;;
  esac
done

echo "🍎 Installing dotfiles for macOS..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Repo:     $DOTFILES_DIR"
echo "Terminal: Ghostty"
echo ""

# Create symlink function
create_symlink() {
  local source="$1"
  local target="$2"
  local name
  name="$(basename "$target")"

  echo "→ $name"

  # Check source exists
  if [ ! -e "$source" ]; then
    echo "  ✗ Source not found: $source"
    return 1
  fi

  # Create parent directory
  mkdir -p "$(dirname "$target")"

  # Handle existing file/directory
  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ -L "$target" ]; then
      # Existing symlink
      if [ "$(readlink "$target")" = "$source" ]; then
        echo "  ✓ Already configured"
        return 0
      fi
      rm "$target"
    else
      # Real file/directory - backup
      local backup
      backup="$target.backup.$(date +%Y%m%d-%H%M%S)"
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
brew install --cask ghostty 2>/dev/null || true
brew install neovim zoxide fzf starship lazygit node ripgrep fd bash 2>/dev/null || true

# Install Zed editor
brew install --cask zed 2>/dev/null || true
echo ""

# Create symlinks
echo "🔗 Creating symlinks..."
create_symlink "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
create_symlink "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES_DIR/zed/settings.json" "$HOME/.config/zed/settings.json"
echo ""

# Make the management scripts executable
chmod +x "$DOTFILES_DIR"/scripts/*.sh "$DOTFILES_DIR/install.sh"

# Create .bash_profile if it doesn't exist (needed for login shells)
if [ ! -f "$HOME/.bash_profile" ]; then
  echo "→ .bash_profile"
  cat >"$HOME/.bash_profile" <<'EOF'
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

# Apply the theme. This generates ghostty/theme.conf, the active cursor shader,
# and nvim/lua/config/theme.lua, and points starship + Zed at the same palette.
echo "🎨 Applying theme..."
if [ -n "$THEME_ARG" ]; then
  "$DOTFILES_DIR/scripts/theme.sh" "$THEME_ARG"
elif [ -f "$DOTFILES_DIR/.theme" ]; then
  "$DOTFILES_DIR/scripts/theme.sh" --reapply
else
  "$DOTFILES_DIR/scripts/theme.sh" tokyonight-night
fi
echo ""

# Optional: Install JUnit Console Standalone for neotest-java
echo "☕ JUnit Console Standalone (for running Java tests in Neovim)"
read -p "   Install JUnit Console Standalone? [y/N] " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  JUNIT_JAR_DIR="$HOME/.local/share/nvim/neotest-java"
  JUNIT_JAR_URL="https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.10.2/junit-platform-console-standalone-1.10.2.jar"
  mkdir -p "$JUNIT_JAR_DIR"
  echo "   Downloading JUnit Console Standalone..."
  curl -L -o "$JUNIT_JAR_DIR/junit-platform-console-standalone.jar" "$JUNIT_JAR_URL" 2>/dev/null
  echo "   ✓ Installed to $JUNIT_JAR_DIR"
else
  echo "   ✗ Skipped"
fi
echo ""

# Success message
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Installation complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Install font manually:"
echo "      brew install font-google-sans-code-nerd-font"
echo "   2. Restart Ghostty"
echo "   3. Open Neovim - plugins will auto-install"
echo "   4. Open Zed and install these extensions manually:"
echo "      • Theme: Tokyo Night   (or Ayu, if you switch to ayu-dark)"
echo "      • Icons: Material Icon Theme"
echo "      (cmd+shift+p → 'zed: extensions')"
echo ""
echo "💡 Quick tips:"
echo "   • Edit files in $DOTFILES_DIR - changes apply instantly"
echo "   • theme              switch the theme across every tool"
echo "   • cfx                switch the Ghostty cursor effect"
echo "   • cross              build a 2x2 split layout in Ghostty"
echo "   • z <dir>            jump with zoxide"
echo "   • Ctrl+R             fzf history search"
echo ""
