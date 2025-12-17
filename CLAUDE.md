# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for a macOS CLI workflow using **Ghostty/Alacritty** + **Bash** + **Zellij** + **LazyVim** + **atuin**. The key architectural principle is **symlinks as source of truth** - the repository IS the live configuration, not just a backup.

## Architecture & Workflow

The repository uses a bidirectional symlink approach:
- Configuration files in this repo are symlinked to their system locations (`~/.config/` and `~/`)
- Changes made to either location are immediately reflected everywhere
- No copying or manual syncing required - edit once, apply everywhere

### Symlink Mappings

The following symlinks are created by `install.sh`:
- `ghostty/` → `~/.config/ghostty/` (primary terminal)
- `alacritty/` → `~/.config/alacritty/` (alternative terminal)
- `atuin/` → `~/.config/atuin/` (shell history)
- `zellij/` → `~/.config/zellij/`
- `bash/.bashrc` → `~/.bashrc`
- `starship/starship.toml` → `~/.config/starship.toml`
- `nvim/` → `~/.config/nvim/`

### Directory Structure

```
├── ghostty/            # Primary terminal emulator config
│   ├── config          # Main config with Ayu Dark theme, cursor trail shader
│   └── shaders/        # Custom GLSL shaders
│       └── cursor_trail.glsl  # Animated cursor trail effect
├── alacritty/          # Alternative terminal emulator config
│   └── alacritty.toml  # Main config with Ayu Dark theme
├── atuin/              # Shell history manager config
│   └── config.toml     # Compact mode, enter_accept=false
├── bash/               # Shell configuration
│   └── .bashrc         # Bash config with atuin, zellij auto-start, fzf, zoxide
├── starship/           # Shell prompt
│   └── starship.toml   # Prompt config with Ayu Dark theme and language modules
├── zellij/             # Terminal multiplexer
│   ├── config.kdl      # Main zellij configuration (keybindings, themes, plugins)
│   └── layouts/        # Custom layouts
│       └── default.kdl # Default layout with Ayu Dark colors
├── nvim/               # Neovim configuration (LazyVim)
│   ├── init.lua        # Entry point
│   ├── lua/
│   │   ├── config/     # Core LazyVim configuration overrides
│   │   │   ├── autocmds.lua
│   │   │   ├── keymaps.lua   # Custom save function with Ctrl+s
│   │   │   ├── options.lua   # scrolloff=8, linebreak settings
│   │   │   └── lazy.lua      # Lazy.nvim plugin manager setup
│   │   └── plugins/    # Plugin customizations
│   │       ├── colorscheme.lua  # Ayu Dark theme
│   │       ├── disabled.lua     # Disabled default plugins
│   │       ├── lazygit.lua      # LazyGit integration
│   │       ├── treesitter.lua   # Syntax highlighting
│   │       └── ui.lua           # UI with Ayu theme
│   └── stylua.toml     # Lua formatter config
├── scripts/            # Management utilities
│   ├── prepare.sh      # Copy existing configs to repo before install
│   └── sync.sh         # Maintenance and status checking
├── install.sh          # Main installation script (creates symlinks, installs tools)
├── README.md           # User-facing documentation (Spanish)
└── CLAUDE.md           # This file - AI assistant context
```

## Common Commands

### Installation & Setup
```bash
# Initial setup (both terminals)
./install.sh

# Install specific terminal
./install.sh --ghostty    # Ghostty only (with atuin)
./install.sh --alacritty  # Alacritty only (no atuin)

# Prepare existing configs (run before install.sh on new machine)
./scripts/prepare.sh

# Check symlink status
./scripts/sync.sh status

# Check git status
./scripts/sync.sh git-status

# Create backup of current configs
./scripts/sync.sh backup
```

### Development Workflow
```bash
# Make changes directly to files in this repo
vim ghostty/config

# Changes are immediately active in the system
# Commit when satisfied
git add . && git commit -m "Update ghostty config"
git push

# On other machines
git pull  # Changes immediately active via symlinks
```

## Key Configuration Details

### Theming Philosophy
All tools use the **Ayu Dark** color scheme for a consistent visual experience:

#### Ghostty (`ghostty/config`)
- **Theme**: Ayu Dark with custom cursor trail shader
- **Font**: Google Sans Code NF, size 18
- **Cursor**: Ayu Dark yellow (#FFB454) with animated trail effect
- **Window**: 240×70 characters, decorations enabled, 10px/5px padding
- **Shell**: Bash with shell integration
- **Shader**: `shaders/cursor_trail.glsl` - Creates motion blur trail effect
- **Colors**:
  - Background: #0A0E14
  - Foreground: #B3B1AD
  - 16-color Ayu Dark palette

#### Alacritty (`alacritty/alacritty.toml`)
- **Theme**: Ayu Dark matching Ghostty
- **Font**: Google Sans Code NF, size 18
- **Window**: 150×30 columns, no decorations, 10px/5px padding
- **Shell**: /bin/bash via terminal config
- **Same Ayu Dark color palette** as Ghostty

#### Starship (`starship/starship.toml`)
- **Custom Ayu Dark palette** (lines 29-53)
- **Modular prompt format**: directory, OS, git branch, language modules, duration, time
- **Language support**: Node.js, Rust, Go, PHP, Bun, Java, C, Zig, Python, Conda
- **Truncates to repo root** with custom directory substitutions
- **Colors match Ayu Dark** theme

#### Zellij (`zellij/config.kdl`)
- **Theme**: ayu_dark built-in
- **Custom keybindings** with `clear-defaults=true`
- **zjstatus plugin** with Ayu Dark colors in `layouts/default.kdl`

#### Neovim (`nvim/lua/plugins/colorscheme.lua`)
- **Theme**: neovim-ayu plugin (ayu-dark variant)
- **Lualine**: "ayu" theme
- **Consistent with terminal** Ayu Dark colors

### Bash Configuration (`bash/.bashrc`)
- **atuin integration** (Ghostty only):
  - Requires bash-preexec for hooks
  - Compact mode (20 lines max)
  - Commands placed in prompt (not executed immediately)
  - Ctrl+R and up-arrow for history search
- **Auto-start Zellij**: Automatically attaches to "main" session
  - Only if not already in Zellij and not in VS Code terminal
- **History settings**: 50k lines, timestamps, no duplicates, append mode
- **Tool initialization**: Starship, Homebrew, zoxide, fzf, atuin
- **FZF Ctrl+R config**: 80% height, reverse layout, hidden preview
- **Aliases**:
  - `ll`, `la`, `l` - ls variations with colors
  - `zda` - Zellij delete all sessions with auto-confirm
  - `k` - kubectl shorthand

### atuin Configuration (`atuin/config.toml`)
- **Style**: compact (inline, not fullscreen)
- **Height**: 20 lines maximum
- **Enter behavior**: `enter_accept = false` - puts command in prompt without executing
- **History**: Synced across machines via SQLite database
- **Only active in Ghostty** (not Alacritty)
- **Requires bash-preexec** for bash integration

### Zellij Configuration (`zellij/config.kdl`)
- **Default mode**: `locked` - Ctrl+g to enter normal mode
- **Keybindings**: Vim-style (`hjkl`) with clear-defaults=true
- **Theme**: ayu_dark
- **Navigation**:
  - Pane mode: `d` (down), `r` (right), `x` (close), `f` (fullscreen), `tab` (switch)
  - Tab mode: `n` (new), `hjkl` (navigate), `1-9` (jump to tab), `r` (rename)
- **Layouts**: `default.kdl` with Ayu Dark zjstatus colors
- **Scrollback editor**: nvim
- **Shell**: bash

### Neovim Configuration (LazyVim)
- **Base**: LazyVim distribution with custom overrides
- **Theme**: Ayu Dark via neovim-ayu plugin
- **Custom keymaps** (`lua/config/keymaps.lua`):
  - Ctrl+s: Custom save function with notifications
- **Options** (`lua/config/options.lua`):
  - `scrolloff = 8` - Keep 8 lines visible above/below cursor
  - `linebreak = true` - Wrap at word boundaries
- **Plugins**:
  - LazyGit integration (`lazygit.lua`)
  - Ayu Dark colorscheme
  - Enhanced UI components with Ayu theme
  - Treesitter for syntax highlighting
  - Some default plugins disabled (`disabled.lua`)

### Important File Locations
Configuration hotspots to monitor:
- `ghostty/config:6` - Font size (18)
- `ghostty/config:17` - Cursor color (Ayu Dark yellow)
- `ghostty/config:21` - Cursor trail shader
- `ghostty/config:52-53` - Window dimensions (240×70)
- `ghostty/shaders/cursor_trail.glsl` - Custom cursor animation
- `alacritty/alacritty.toml:6` - Font size (18)
- `atuin/config.toml:68` - Style (compact)
- `atuin/config.toml:72` - Inline height (20)
- `atuin/config.toml:159` - Enter accept behavior (false)
- `starship/starship.toml:29` - Active color palette (ayu_dark)
- `bash/.bashrc:36-42` - atuin initialization (Ghostty only)
- `bash/.bashrc:57-62` - Zellij auto-start logic
- `zellij/config.kdl:1` - Active theme (ayu_dark)
- `zellij/layouts/default.kdl` - zjstatus Ayu Dark colors
- `nvim/lua/plugins/colorscheme.lua` - Ayu Dark theme config

## Maintenance Notes

### Critical Symlink Behavior
- **Repository uses symlinks**: Direct editing of system files affects the repo
- **Immediate propagation**: Changes in repo are instantly active (except shell config requires reload)
- **Git tracking**: System changes appear in `git status` immediately
- **Verification**: Run `./scripts/sync.sh status` to check symlink integrity
- **Software vs Config**: atuin, ble.sh are installed software (not in repo). Only configs are symlinked.

### Backup Strategy
- `install.sh` creates timestamped backups before creating symlinks
- `./scripts/sync.sh backup` creates manual backups of non-symlinked configs
- **Never overwrites** existing symlinks pointing to the repo

### Installation Script (`install.sh`)
- **Terminal selection**: `--ghostty`, `--alacritty`, or both (default)
- **atuin installation**: Only installed with Ghostty
- **bash-preexec**: Downloaded automatically when Ghostty is installed
- **Symlinks**: Validates source files, creates parent directories, handles existing files gracefully
- **Auto-installs tools**: atuin, zellij, neovim, zoxide, fzf, starship via Homebrew
- **Idempotent**: Safe to run multiple times

### Management Scripts
- `scripts/prepare.sh`: Copies existing system configs to repo (run before first install)
- `scripts/sync.sh`:
  - `status` - Verifies all symlinks point to repo
  - `git-status` - Shows repo status and recent commits
  - `backup` - Creates timestamped backup of non-symlinked configs

## Dependencies & Tools

### Required Tools (auto-installed by install.sh)
- **Homebrew**: Package manager for macOS
- **Ghostty**: Primary terminal emulator with shader support
- **Alacritty**: Alternative terminal emulator
- **atuin**: Shell history manager with sync (Ghostty only)
- **zellij**: Terminal multiplexer
- **neovim**: Text editor with LazyVim distribution
- **zoxide**: Smart directory navigation (`z <pattern>`, `zi` for interactive)
- **fzf**: Fuzzy finder (Ctrl+R history, Ctrl+T files, Alt+C change dir)
- **starship**: Cross-shell prompt

### Required Fonts (manual installation)
- **Google Sans Code NF**: Nerd Font required for icons
  - Install: `brew tap homebrew/cask-fonts && brew install font-google-sans-code-nerd-font`

### Runtime Dependencies (auto-installed)
- **bash-preexec**: Bash hooks for atuin (auto-downloaded to `~/.bash-preexec.sh`)
- Located at: `~/.bash-preexec.sh` (not in repo)

### System Requirements
- **OS**: macOS (uses Homebrew, macOS-specific paths)
- **Shell**: Bash 5.2+ (installed via Homebrew, not default macOS bash 3.2)
- **Terminal**: Ghostty (primary) or Alacritty
- **Graphics**: OpenGL support for Ghostty shaders

## Workflow Best Practices

### Making Configuration Changes
1. Edit files directly in this repo (e.g., `vim ghostty/config`)
2. Changes apply immediately to system via symlinks
3. Test the changes in your terminal/editor
4. Commit when satisfied: `git add . && git commit -m "Change cursor color"`
5. Push to sync across machines: `git push`

### Syncing to Other Machines
1. Clone repo: `git clone <url> ~/code/felipecarlos/dotfiles`
2. Run installation: `cd ~/code/felipecarlos/dotfiles && ./install.sh`
3. Install font: `brew tap homebrew/cask-fonts && brew install font-google-sans-code-nerd-font`
4. Restart terminal (Ghostty or Alacritty)
5. Future updates: just `git pull` (changes apply instantly)

### Troubleshooting
- **Config not applying**: Check `./scripts/sync.sh status` for broken symlinks
- **atuin not working**: Ensure you're using Ghostty and bash-preexec exists at `~/.bash-preexec.sh`
- **Cursor trail not showing**: Restart Ghostty, check shader file exists in `ghostty/shaders/`
- **Terminal not starting Zellij**: Check `.bashrc` auto-start logic (lines 57-62)
- **Icons not showing**: Install Google Sans Code NF (Nerd Font)
- **Command not found**: Source `.bashrc` or restart terminal after install
- **Double prompt in Ghostty**: Known limitation of bash-preexec (accepted for performance)

## Special Features

### Ghostty Cursor Trail Shader
- **File**: `ghostty/shaders/cursor_trail.glsl`
- **Effect**: Animated trail showing cursor movement path
- **Color**: Ayu Dark yellow (#FFB454)
- **Performance**: Minimal overhead, GPU-accelerated
- **Inspiration**: Gentleman.Dots configuration

### atuin Shell History
- **Activation**: Only in Ghostty (Ctrl+R or up-arrow)
- **Mode**: Compact inline (20 lines)
- **Behavior**: Select command → placed in prompt → edit or execute
- **Sync**: History synced across machines via SQLite
- **Integration**: Requires bash-preexec for bash support
- **Performance**: Fast fuzzy search across entire history

### Zellij Auto-start
- **Behavior**: Automatically attaches to "main" session on terminal launch
- **Conditions**: Only if not already in Zellij and not in VS Code terminal
- **Session**: Persistent "main" session across terminal restarts
- **Layout**: Uses `default.kdl` with Ayu Dark zjstatus colors
