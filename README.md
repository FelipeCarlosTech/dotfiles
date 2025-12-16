# Dotfiles - macOS CLI Setup

**Stack**: Alacritty / Ghostty + Bash + Zellij + LazyVim + Starship
**Theme**: Ayu Dark
**Font**: Google Sans Code NF

## Quick Setup (New Mac)

```bash
# Clone repo
git clone git@github.com:FelipeCarlosTech/dotfiles.git ~/code/felipecarlos/dotfiles
cd ~/code/felipecarlos/dotfiles

# Install everything
chmod +x install.sh

# Install both terminals (default)
./install.sh

# OR install only Ghostty
./install.sh --ghostty

# OR install only Alacritty
./install.sh --alacritty
```

**What gets installed automatically:**
- ✅ Alacritty (terminal emulator)
- ✅ Ghostty (modern terminal emulator)
- ✅ Zellij (terminal multiplexer)
- ✅ Neovim (text editor)
- ✅ Starship (shell prompt)
- ✅ zoxide (smart cd)
- ✅ fzf (fuzzy finder)
- ✅ All config symlinks

**Manual step (required):**
```bash
brew tap homebrew/cask-fonts
brew install font-google-sans-code-nerd-font
```

**That's it!** Restart your terminal and you're ready.

## How It Works

This setup uses **symlinks** - the repo IS your live configuration:
- Edit files in this repo → Changes apply instantly to your system
- No copying back and forth
- `git pull` on new machines = instant config sync

## Essential Tools

### Zoxide (Smart CD)
```bash
z dotfiles    # Jump to ~/code/felipecarlos/dotfiles
zi            # Interactive directory picker
```

### FZF (Fuzzy Finder)
- `Ctrl+R` - Search command history
- `Ctrl+T` - Find files
- `Alt+C` - Change directory

### Zellij (Terminal Multiplexer)
- Auto-starts with terminal
- `Ctrl+g` to unlock/enter normal mode
- Press `t` for tab mode, `p` for pane mode

## Sync Across Machines

On your current Mac:
```bash
git add .
git commit -m "Update config"
git push
```

On your new Mac:
```bash
cd ~/code/felipecarlos/dotfiles
git pull
```

Changes apply instantly via symlinks!

## Switching Themes

All configs have **Carbonfox backup** commented out. To revert:
1. Uncomment Carbonfox sections
2. Comment out Ayu Dark sections

Files to check:
- `alacritty/alacritty.toml`
- `starship/starship.toml`
- `zellij/config.kdl`
- `zellij/layouts/default.kdl`
- `nvim/lua/plugins/colorscheme.lua`
- `nvim/lua/plugins/ui.lua`

## Customization

### Change Font Size
Edit `alacritty/alacritty.toml:146`
```toml
size = 18  # Change to your preference
```

### Manage Zellij Sessions
```bash
zellij ls              # List sessions
zellij attach main     # Attach to main session
zda                    # Delete all sessions (custom alias)
```

### LazyVim
Opens on first Neovim launch and installs plugins automatically.

## Utilities

```bash
./scripts/sync.sh status      # Check symlink health
./scripts/sync.sh git-status  # Quick git status
./scripts/sync.sh backup      # Create config backup
```
