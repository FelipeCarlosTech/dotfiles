# 🚀 Modern macOS Terminal Setup

A complete, production-ready dotfiles configuration for macOS developers featuring **Ghostty**, **Zellij**, **LazyVim**, and **atuin** with a beautiful **Ayu Dark** theme.

[![macOS](https://img.shields.io/badge/macOS-Sequoia+-blue.svg)](https://www.apple.com/macos/)
[![Shell](https://img.shields.io/badge/Shell-Bash_5.2+-green.svg)](https://www.gnu.org/software/bash/)
[![Theme](https://img.shields.io/badge/Theme-Ayu_Dark-orange.svg)](https://github.com/ayu-theme)

## ✨ What's Inside

### 🖥️ Core Stack

| Component | Tool | Purpose |
|-----------|------|---------|
| **Terminal** | [Ghostty](https://ghostty.org) / [Alacritty](https://alacritty.org) | GPU-accelerated terminal with custom shaders |
| **Shell** | [Bash 5.2+](https://www.gnu.org/software/bash/) | Modern Bash shell (not default macOS 3.2) |
| **Multiplexer** | [Zellij](https://zellij.dev) | Modern terminal workspace manager |
| **Editor** | [Neovim](https://neovim.io) + [LazyVim](https://www.lazyvim.org) | Blazingly fast IDE-like experience |
| **Prompt** | [Starship](https://starship.rs) | Fast, customizable shell prompt |
| **History** | [atuin](https://atuin.sh) | Magical shell history with sync |
| **Navigation** | [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter cd command |
| **Finder** | [fzf](https://github.com/junegunn/fzf) | Fuzzy finder for everything |

### 🎨 Theme & Appearance

- **Color Scheme**: Ayu Dark (consistent across all tools)
- **Font**: Google Sans Code Nerd Font (size 18)
- **Cursor**: Animated trail effect with Ayu Dark yellow
- **Icons**: Full Nerd Font icon support

## 🌟 Key Features

### ⚡ Ghostty Terminal
- Custom **cursor trail shader** (animated motion blur effect)
- Native macOS performance with GPU acceleration
- Ayu Dark theme with vibrant yellow cursor
- Shell integration with inline completions

### 🔍 atuin Shell History
- **Fuzzy searchable** history across all sessions
- **Compact inline mode** - no fullscreen interruption
- Commands placed in prompt (edit before executing)
- Sync history across machines
- Only active in Ghostty for best performance

### 🪟 Zellij Workspace
- **Auto-starts** with terminal (persistent sessions)
- Vim-style navigation (`hjkl`)
- Custom keybindings with `Ctrl+g` unlock
- Ayu Dark theme with custom status bar
- Tabs, panes, and floating windows

### 🎯 LazyVim Configuration
- Pre-configured IDE experience out of the box
- Ayu Dark colorscheme
- LSP, treesitter, telescope, and more
- Custom keymaps (Ctrl+s to save)
- LazyGit integration

### 🔄 Symlink Architecture
- **Repository is the source of truth**
- Changes apply instantly (no sync needed)
- `git pull` = instant config update across machines
- Edit once, deploy everywhere

## 📦 Installation

### Prerequisites
- macOS Sequoia+ (or any recent macOS version)
- [Homebrew](https://brew.sh) (will be installed if missing)
- Git

### Quick Start

```bash
# 1. Clone this repository
git clone https://github.com/FelipeCarlosTech/dotfiles.git ~/code/felipecarlos/dotfiles
cd ~/code/felipecarlos/dotfiles

# 2. Make install script executable
chmod +x install.sh

# 3. Choose your installation:

# Install both terminals (Ghostty + Alacritty)
./install.sh

# OR install only Ghostty (recommended)
./install.sh --ghostty

# OR install only Alacritty (no atuin)
./install.sh --alacritty
```

### What Gets Installed

The installation script automatically installs:

✅ **Terminal Emulators**
- Ghostty (modern, GPU-accelerated)
- Alacritty (alternative, battle-tested)

✅ **Development Tools**
- Zellij (terminal multiplexer)
- Neovim (text editor)
- atuin (shell history, Ghostty only)

✅ **CLI Utilities**
- Starship (prompt)
- zoxide (smart cd)
- fzf (fuzzy finder)
- bash-preexec (atuin integration)

✅ **Configuration**
- All config files symlinked
- Ayu Dark theme applied everywhere
- Custom cursor trail shader (Ghostty)

### Manual Step (Required)

Install the Nerd Font for icons:

```bash
brew tap homebrew/cask-fonts
brew install font-google-sans-code-nerd-font
```

### Post-Installation

1. **Restart your terminal** (or open Ghostty/Alacritty)
2. **First Neovim launch**: Run `nvim` - plugins will auto-install
3. **Done!** 🎉

## 🎮 Usage Guide

### Essential Keyboard Shortcuts

#### Zellij (Terminal Multiplexer)
```
Ctrl+g          # Unlock/Enter normal mode
Press t         # Tab mode (create, switch, rename tabs)
Press p         # Pane mode (split, navigate, resize)
Press 1-9       # Jump to specific tab
```

#### atuin (Shell History - Ghostty only)
```
Ctrl+R          # Search history (compact inline mode)
Up Arrow        # Previous command in history
Enter           # Place command in prompt (don't execute)
Enter again     # Execute the command
```

#### fzf (Fuzzy Finder)
```
Ctrl+R          # Search command history (in Alacritty)
Ctrl+T          # Find files
Alt+C           # Change directory interactively
```

#### zoxide (Smart Navigation)
```bash
z dotfiles      # Jump to any directory containing "dotfiles"
z ~/code        # Jump to ~/code
zi              # Interactive directory picker
```

### Common Commands

```bash
# Zellij session management
zellij ls                    # List all sessions
zellij attach main           # Attach to main session
zda                          # Delete all sessions (alias)

# Config verification
./scripts/sync.sh status     # Check symlink health
./scripts/sync.sh git-status # Quick git status

# Manual backup (optional)
./scripts/sync.sh backup     # Create timestamped backup
```

## ⚙️ Configuration

### File Structure

```
dotfiles/
├── ghostty/              # Primary terminal config
│   ├── config           # Main configuration
│   └── shaders/         # Custom GLSL shaders
├── alacritty/           # Alternative terminal config
├── atuin/               # Shell history config
├── bash/                # Shell configuration
├── starship/            # Prompt configuration
├── zellij/              # Multiplexer config
│   ├── config.kdl
│   └── layouts/
└── nvim/                # Neovim configuration
    └── lua/
        ├── config/
        └── plugins/
```

### Customization Examples

#### Change Font Size
Edit `ghostty/config`:
```
font-size = 18  # Change to your preference
```

Or `alacritty/alacritty.toml`:
```toml
size = 18
```

#### Adjust atuin History Height
Edit `atuin/config.toml`:
```toml
inline_height = 20  # Lines to show (default: 20)
```

#### Modify Cursor Trail Color
Edit `ghostty/config`:
```
cursor-color = #FFB454  # Any hex color
```

#### Change Terminal Window Size
Edit `ghostty/config`:
```
window-width = 240   # Characters wide
window-height = 70   # Lines tall
```

## 🔄 Syncing Across Machines

### Making Changes

```bash
# 1. Edit any config file in the repo
vim ghostty/config

# 2. Changes apply instantly (symlinked)
# Test in your terminal

# 3. Commit and push
git add .
git commit -m "Update cursor color"
git push
```

### Syncing to Another Mac

```bash
# On your new Mac (after initial setup):
cd ~/code/felipecarlos/dotfiles
git pull

# Changes apply instantly via symlinks!
```

## 🎨 Theme Customization

All configurations use **Ayu Dark** theme with these colors:

| Element | Color | Hex |
|---------|-------|-----|
| Background | Dark Charcoal | `#0A0E14` |
| Foreground | Light Gray | `#B3B1AD` |
| Cursor | Bright Yellow | `#FFB454` |
| Selection | Dark Blue | `#253340` |
| Red | Coral | `#EA6C73` |
| Green | Lime | `#91B362` |
| Yellow | Orange | `#F9AF4F` |
| Blue | Sky Blue | `#53BDFA` |

### Switching Themes

Want to use a different theme? Update these files:
- `ghostty/config` - Terminal colors
- `alacritty/alacritty.toml` - Terminal colors
- `starship/starship.toml` - Prompt palette
- `zellij/config.kdl` - Multiplexer theme
- `nvim/lua/plugins/colorscheme.lua` - Editor theme

## 🛠️ Troubleshooting

### Terminal not loading config
```bash
# Check symlink status
./scripts/sync.sh status

# Verify symlinks point to repo
ls -la ~/.config/ghostty
# Should show: ~/.config/ghostty -> ~/code/felipecarlos/dotfiles/ghostty
```

### atuin not working
- **Check**: Are you using Ghostty? (atuin only works in Ghostty)
- **Check**: Does `~/.bash-preexec.sh` exist?
- **Fix**: Run `./install.sh --ghostty` again

### Cursor trail not showing
- **Fix**: Restart Ghostty completely (Cmd+Q, then reopen)
- **Check**: Verify `ghostty/shaders/cursor_trail.glsl` exists

### Icons not displaying
- **Fix**: Install the Nerd Font:
  ```bash
  brew tap homebrew/cask-fonts
  brew install font-google-sans-code-nerd-font
  ```
- **Fix**: Restart your terminal

### Zellij not auto-starting
- **Check**: `.bashrc` line 57-62 (auto-start logic)
- **Fix**: Run `source ~/.bashrc`

### Commands not found
- **Fix**: Source bashrc: `source ~/.bashrc`
- **Fix**: Or restart your terminal

## 🤝 Contributing

Found a bug or want to suggest an improvement? Feel free to:
1. Open an issue
2. Submit a pull request
3. Fork and customize for your own use

## 📝 License

This configuration is free and open source. Feel free to use, modify, and distribute.

## 🙏 Credits

Inspired by and using:
- [Ayu Theme](https://github.com/ayu-theme/ayu-colors) - Color scheme
- [Gentleman.Dots](https://github.com/Gentleman-Programming/Gentleman.Dots) - Cursor trail shader
- [LazyVim](https://www.lazyvim.org) - Neovim configuration
- The amazing open source community

## 📬 Contact

Created by [@FelipeCarlosTech](https://github.com/FelipeCarlosTech)

If you found this helpful, consider giving it a ⭐!

---

**Note**: This setup is optimized for macOS. Linux users may need to adjust paths and installation commands.
