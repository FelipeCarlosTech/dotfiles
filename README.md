# 🚀 Modern macOS Terminal Setup

A complete, production-ready dotfiles configuration for macOS developers featuring **Ghostty**, **LazyVim**, and **Starship** — with a **switchable theme system** (Tokyo Night by default).

[![macOS](https://img.shields.io/badge/macOS-Sequoia+-blue.svg)](https://www.apple.com/macos/)
[![Shell](https://img.shields.io/badge/Shell-Bash_5.2+-green.svg)](https://www.gnu.org/software/bash/)
[![Theme](https://img.shields.io/badge/Theme-Tokyo_Night-7aa2f7.svg)](https://github.com/folke/tokyonight.nvim)

## ✨ What's Inside

### 🖥️ Core Stack

| Component | Tool | Purpose |
|-----------|------|---------|
| **Terminal** | [Ghostty](https://ghostty.org) | GPU-accelerated terminal with custom shaders, native splits & tabs |
| **Shell** | [Bash 5.2+](https://www.gnu.org/software/bash/) | Modern Bash shell (not default macOS 3.2) |
| **Editor** | [Neovim](https://neovim.io) + [LazyVim](https://www.lazyvim.org) | Blazingly fast IDE-like experience |
| **Editor (GUI)** | [Zed](https://zed.dev) | Fast native editor with vim mode |
| **Prompt** | [Starship](https://starship.rs) | Fast, customizable shell prompt |
| **History** | [fzf](https://github.com/junegunn/fzf) | Fuzzy history search with Ctrl+R |
| **Navigation** | [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter cd command |

> **No multiplexer.** Zellij was removed in favor of Ghostty's native splits and
> tabs. One less layer, one less config, native performance.

### 🎨 Theme & Appearance

- **Themes**: Tokyo Night (Night / Storm) and Ayu Dark — switch with one command
- **Font**: Google Sans Code Nerd Font (size 15)
- **Cursor**: 10 selectable animated shader effects, auto-tinted to the active theme
- **Icons**: Full Nerd Font icon support

## 🌟 Key Features

### 🎨 One-Command Theming

Every tool's colors come from a **single file per theme**. No more hunting hex codes
across five configs:

```bash
theme                     # List themes, show the active one
theme tokyonight-night    # Apply everywhere: Ghostty, Starship, Neovim, Zed, shaders
theme ayu-dark            # Switch back instantly
```

```
themes/<name>.sh   ──►   scripts/theme.sh   ──►   Ghostty + shaders + Starship + Neovim + Zed
   (source of truth)         (one command)              (all in sync, always)
```

### ⚡ Ghostty Terminal

- **10 cursor shader effects** — smear, ripple, bloom, ghost, fire, rainbow, breathe…
- Switch effects live: `cfx bloom` (the shader is re-tinted to your theme automatically)
- Native splits and tabs with vim-style navigation
- GPU acceleration and shell integration

### 🎯 LazyVim Configuration

- Pre-configured IDE experience out of the box
- Colorscheme driven by the central theme system
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
# 1. Clone this repository (any path works — the installer resolves its own location)
git clone https://github.com/FelipeCarlosTech/dotfiles.git ~/code/felipecarlos/dotfiles
cd ~/code/felipecarlos/dotfiles

# 2. Install
./install.sh

# Or pick a theme up front:
./install.sh --theme tokyonight-storm
./install.sh --theme ayu-dark
```

### What Gets Installed

✅ **Applications** — Ghostty, Neovim, Zed
✅ **CLI Utilities** — Starship, zoxide, fzf, lazygit, ripgrep, fd, node, bash
✅ **Configuration** — all configs symlinked, theme generated and applied

### Manual Steps (Required)

```bash
# Nerd Font for icons
brew install font-google-sans-code-nerd-font
```

In Zed, install these extensions (`cmd+shift+p` → `zed: extensions`):
- **Theme**: Tokyo Night (or Ayu, if you use `ayu-dark`)
- **Icons**: Material Icon Theme

### Post-Installation

1. **Restart Ghostty**
2. **First Neovim launch**: run `nvim` — plugins auto-install
3. **Done!** 🎉

## 🎮 Usage Guide

### Ghostty Splits & Tabs

```
cmd+d              # Split right
cmd+shift+d        # Split down
cmd+alt+h/j/k/l    # Move focus between splits (vim-style)
cmd+ctrl+h/j/k/l   # Resize the focused split
cmd+ctrl+r         # Equalize all splits
cmd+shift+enter    # Zoom the focused split
cmd+w              # Close the split

cmd+t              # New tab
cmd+shift+h/l      # Previous / next tab
cmd+1..9           # Jump to a tab
```

#### 4 panes in a cross (2×2)

Ghostty maps one shortcut to exactly one action and has no layout files, so the
cross is four keystrokes:

```
cmd+d  →  cmd+shift+d  →  cmd+alt+h  →  cmd+shift+d
```

Then `cmd+ctrl+r` to even them out. Or do it in one shot:

```bash
cross              # Builds the 2x2 layout in the current window
```

> `cross` drives those keystrokes through System Events, so it needs Accessibility
> permission (System Settings → Privacy & Security → Accessibility). The script
> tells you if the permission is missing instead of failing silently.

### Theme & Cursor

```bash
theme                      # List themes, show active
theme tokyonight-night     # Apply a theme everywhere
theme tokyonight-storm
theme ayu-dark
theme --reapply            # Regenerate artifacts for the active theme

cfx                        # List cursor effects, show active
cfx bloom                  # Switch effect (auto-tinted to the theme)
cfx 5                      # By number
```

After either, press `Cmd+Shift+,` in Ghostty to reload.

### fzf (Fuzzy Finder)

```
Ctrl+R          # Search command history
Ctrl+T          # Find files
Alt+C           # Change directory interactively
```

### zoxide (Smart Navigation)

```bash
z dotfiles      # Jump to any directory containing "dotfiles"
zi              # Interactive directory picker
```

### Maintenance

```bash
./scripts/sync.sh status     # Symlinks, active theme, generated artifacts
./scripts/sync.sh git-status # Quick git status
./scripts/sync.sh backup     # Create timestamped backup
```

## ⚙️ Configuration

### File Structure

```
dotfiles/
├── themes/               # ★ SOURCE OF TRUTH — one file per theme
│   ├── tokyonight-night.sh
│   ├── tokyonight-storm.sh
│   └── ayu-dark.sh
├── ghostty/              # Terminal config
│   ├── config            # Settings + keybindings (no colors)
│   ├── theme.conf        # GENERATED colors
│   └── shaders/
│       ├── active_cursor.glsl   # GENERATED (gitignored)
│       └── effects/             # 10 cursor effect templates
├── bash/                 # Shell configuration
├── starship/             # Prompt (all palettes live here)
├── zed/                  # Zed editor settings
├── nvim/                 # Neovim configuration
│   └── lua/
│       ├── config/
│       │   └── theme.lua        # GENERATED colorscheme + lualine
│       └── plugins/
├── scripts/
│   ├── theme.sh          # Apply a theme across every tool
│   ├── cursor-fx.sh      # Switch cursor effect
│   ├── ghostty-cross.sh  # Build the 2x2 split layout
│   ├── sync.sh           # Maintenance & verification
│   └── prepare.sh        # Pre-install config capture
├── .theme                # Active theme marker
└── .cursor-fx            # Active cursor effect marker
```

Files marked **GENERATED** are written by `scripts/theme.sh`. Don't edit them —
edit the theme file and re-run.

### Customization Examples

#### Change font size

Edit `ghostty/config`:
```
font-size = 15
```

#### Change the cursor / accent color

Edit the active theme file, e.g. `themes/tokyonight-night.sh`:
```bash
CURSOR="#e0af68"   # try "#7aa2f7" (blue) or "#bb9af7" (magenta)
```
Then `theme --reapply`. This recolors the Ghostty cursor **and** the shader effect.

#### Change terminal window size

Edit `ghostty/config`:
```
window-width = 180   # Characters wide
window-height = 45   # Lines tall
```

## 🎨 Theme System

### Adding your own theme

1. Copy an existing file in `themes/` and fill in every variable.
2. Add a matching `[palettes.<name>]` block in `starship/starship.toml`, using the
   same keys as the others (`bg`, `fg`, `muted`, `red`, `green`, `yellow`, `blue`,
   `magenta`, `cyan`, `accent`).
3. Add the Neovim colorscheme plugin to `nvim/lua/plugins/colorscheme.lua`.
4. Run `theme <your-name>`.

`theme.sh` fails loudly if a theme file is missing any required variable, so a
half-finished theme can never silently leave a tool on the old colors.

### Tokyo Night (Night) palette

| Element | Hex |
|---------|-----|
| Background | `#1a1b26` |
| Foreground | `#c0caf5` |
| Cursor / accent | `#e0af68` |
| Selection | `#283457` |
| Red | `#f7768e` |
| Green | `#9ece6a` |
| Blue | `#7aa2f7` |
| Magenta | `#bb9af7` |
| Cyan | `#7dcfff` |

## 🔄 Syncing Across Machines

```bash
# Make changes
vim ghostty/config          # applies instantly via symlink
git add . && git commit -m "Update cursor color" && git push

# On another Mac
cd ~/code/felipecarlos/dotfiles && git pull
./scripts/theme.sh --reapply   # regenerate the gitignored shader
```

## 🛠️ Troubleshooting

### Terminal not loading config

```bash
./scripts/sync.sh status
ghostty +validate-config --config-file="$PWD/ghostty/config"
```

### Colors look wrong or half-applied

```bash
theme --reapply     # regenerates every artifact from the active theme
```
Then `Cmd+Shift+,` in Ghostty and restart Neovim.

### Cursor effect not showing

- Restart Ghostty completely (`Cmd+Q`, then reopen), or press `Cmd+Shift+,`
- Verify `ghostty/shaders/active_cursor.glsl` exists — it's generated and
  gitignored, so a fresh clone needs `theme --reapply`

### `cross` does nothing

macOS is blocking synthetic keystrokes. Grant Accessibility permission in
System Settings → Privacy & Security → Accessibility, or press the four
shortcuts by hand.

### Icons not displaying

```bash
brew install font-google-sans-code-nerd-font
```
Then restart your terminal.

### Commands not found

```bash
source ~/.bashrc    # or restart your terminal
```

## 🤝 Contributing

Found a bug or want to suggest an improvement? Feel free to:
1. Open an issue
2. Submit a pull request
3. Fork and customize for your own use

## 📝 License

This configuration is free and open source. Feel free to use, modify, and distribute.

## 🙏 Credits

Inspired by and using:
- [Tokyo Night](https://github.com/folke/tokyonight.nvim) - Default color scheme
- [Ayu Theme](https://github.com/ayu-theme/ayu-colors) - Alternative color scheme
- [Gentleman.Dots](https://github.com/Gentleman-Programming/Gentleman.Dots) - Cursor shader inspiration
- [LazyVim](https://www.lazyvim.org) - Neovim configuration
- The amazing open source community

## 📬 Contact

Created by [@FelipeCarlosTech](https://github.com/FelipeCarlosTech)

If you found this helpful, consider giving it a ⭐!

---

**Note**: This setup is optimized for macOS. Linux users may need to adjust paths and installation commands.
