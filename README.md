# 🚀 Ghostty Dotfiles — a themeable macOS terminal setup

An opinionated macOS terminal environment built on **Ghostty**, **Bash**, **LazyVim** and **Starship** — where changing the entire color scheme is **one command**, not an afternoon of editing config files.

[![macOS](https://img.shields.io/badge/macOS-Sequoia+-blue.svg)](https://www.apple.com/macos/)
[![Shell](https://img.shields.io/badge/Shell-Bash_5.2+-green.svg)](https://www.gnu.org/software/bash/)
[![Terminal](https://img.shields.io/badge/Terminal-Ghostty-c0caf5.svg)](https://ghostty.org)
[![Theme](https://img.shields.io/badge/Theme-Tokyo_Night-7aa2f7.svg)](https://github.com/folke/tokyonight.nvim)

```bash
theme tokyonight-night   # terminal, prompt, editor and cursor shader — all at once
theme ayu-dark           # changed your mind? one command back
```

---

## Why this repo

Most dotfiles repos hardcode their color scheme in every tool. Ten files, forty hex
values, and no way to try a different theme without a find-and-replace spree. This
one had that exact problem — Ghostty's 16-color palette, nine GLSL shader constants,
a dozen loose hex values in the Starship prompt, plus the Neovim colorscheme. Some
of those values were even leftovers from a theme that had been abandoned months
earlier.

So the colors were pulled out into **one file per theme**:

```
themes/<name>.sh   ──►   scripts/theme.sh   ──►   Ghostty · shaders · Starship · Neovim
 (source of truth)          (one command)              (always in sync)
```

Run `theme <name>` and it regenerates Ghostty's palette, re-tints the animated
cursor shader, rewrites the Neovim colorscheme, and repoints the Starship prompt.
Nothing drifts, because nothing is duplicated.

Ships with **Tokyo Night** (Night and Storm) and **Ayu Dark**. Adding your own is
one file — see [Make it yours](#-make-it-yours).

## ✨ What you get

| Component | Tool | Why |
|-----------|------|-----|
| **Terminal** | [Ghostty](https://ghostty.org) | GPU-accelerated, custom GLSL shaders, native splits & tabs |
| **Shell** | [Bash 5.2+](https://www.gnu.org/software/bash/) | Modern Bash, not the macOS-bundled 3.2 |
| **Editor** | [Neovim](https://neovim.io) + [LazyVim](https://www.lazyvim.org) | IDE experience with sane defaults |
| **Prompt** | [Starship](https://starship.rs) | Fast, fully themed via the central palette |
| **History** | [fzf](https://github.com/junegunn/fzf) | Fuzzy history and file search |
| **Navigation** | [zoxide](https://github.com/ajeetdsouza/zoxide) | `z <partial-name>` instead of `cd ../../..` |

Plus:

- **10 animated cursor shader effects** — smear, ripple, bloom, ghost, fire,
  rainbow, breathe and more. Swap live with `cfx bloom`; each one is automatically
  re-tinted to the active theme.
- **No multiplexer.** Ghostty's native splits and tabs replaced Zellij — one less
  layer, one less config, native performance.
- **Symlinks as source of truth.** The repo *is* the live configuration. Edit a file
  here and it is active immediately; `git pull` on another Mac applies everything.

## 📦 Installation

### Prerequisites

- macOS (developed on Sequoia; recent versions should work)
- [Homebrew](https://brew.sh) — installed automatically if missing
- Git

### Install

```bash
git clone https://github.com/FelipeCarlosTech/dotfiles.git ~/code/felipecarlos/dotfiles
cd ~/code/felipecarlos/dotfiles
./install.sh
```

Clone it anywhere you like — the installer resolves its own location, so the path
is not baked in.

Want to pick a theme up front?

```bash
./install.sh --theme tokyonight-storm
./install.sh --theme ayu-dark
```

The installer is **idempotent** — safe to re-run. It backs up any real config file
it would replace to `<file>.backup.<timestamp>` and never clobbers an existing
symlink that already points here.

<details>
<summary><strong>Already have configs you want to keep?</strong></summary>

Run this **before** `install.sh` to copy your current configs into the repo, so
they become the starting point instead of being backed up and replaced:

```bash
./scripts/prepare.sh
```

</details>

### What it installs

- **Apps** — Ghostty, Neovim
- **CLI** — Starship, zoxide, fzf, lazygit, ripgrep, fd, node, bash
- **Config** — everything symlinked, theme generated and applied

### One manual step

```bash
brew install font-google-sans-code-nerd-font
```

A Nerd Font is required for the icons in the prompt and editor. Prefer a different
font? Change `font-family` in `ghostty/config` — any Nerd Font works.

### Then

1. Restart Ghostty
2. Run `nvim` — plugins install themselves on first launch
3. Done 🎉

## 🎮 Usage

### Theme & cursor

```bash
theme                      # list themes, show the active one
theme tokyonight-night     # apply everywhere
theme tokyonight-storm
theme ayu-dark
theme --reapply            # regenerate everything for the active theme

cfx                        # list cursor effects, show the active one
cfx bloom                  # switch by name
cfx 5                      # or by number
```

Press `Cmd+Shift+,` in Ghostty afterwards to reload.

### Splits & tabs

```
cmd+d              Split right
cmd+shift+d        Split down
cmd+alt+h/j/k/l    Move focus between splits (vim-style)
cmd+ctrl+h/j/k/l   Resize the focused split
cmd+ctrl+r         Equalize all splits
cmd+shift+enter    Zoom the focused split
cmd+w              Close the split

cmd+t              New tab
cmd+shift+h/l      Previous / next tab
cmd+1..9           Jump to a tab
```

#### Four panes in a cross (2×2)

Ghostty maps one shortcut to exactly one action and has no layout files, so the
cross is four keystrokes:

```
cmd+d  →  cmd+shift+d  →  cmd+alt+h  →  cmd+shift+d
```

Then `cmd+ctrl+r` to even them out. Or do it in one shot:

```bash
cross
```

> `cross` sends those keystrokes through System Events, so macOS requires
> Accessibility permission (System Settings → Privacy & Security → Accessibility).
> Without it the script tells you and prints the manual shortcuts instead of
> failing silently.

### Search & navigation

```
Ctrl+R          Fuzzy-search command history
Ctrl+T          Find files
Alt+C           Change directory interactively
z <name>        Jump to a directory by partial name
zi              Interactive directory picker
```

### Maintenance

```bash
./scripts/sync.sh status      # symlinks, active theme, generated artifacts
./scripts/sync.sh git-status  # repo status and recent commits
./scripts/sync.sh backup      # timestamped backup of non-symlinked configs
```

## 🗂️ Repo structure

```
dotfiles/
├── themes/                       ★ SOURCE OF TRUTH — one file per theme
│   ├── tokyonight-night.sh
│   ├── tokyonight-storm.sh
│   └── ayu-dark.sh
├── ghostty/
│   ├── config                    settings + keybindings (no colors)
│   ├── theme.conf                GENERATED colors
│   └── shaders/
│       ├── active_cursor.glsl    GENERATED (gitignored)
│       └── effects/              10 cursor effect templates
├── bash/.bashrc                  shell config and aliases
├── starship/starship.toml        prompt — every palette lives here
├── nvim/                         LazyVim configuration
│   └── lua/config/theme.lua      GENERATED colorscheme + lualine names
├── scripts/
│   ├── theme.sh                  apply a theme across every tool
│   ├── cursor-fx.sh              switch the cursor effect
│   ├── ghostty-cross.sh          build the 2×2 split layout
│   ├── sync.sh                   verification and backups
│   └── prepare.sh                capture existing configs pre-install
├── install.sh
├── .theme                        active theme marker
└── .cursor-fx                    active cursor effect marker
```

Files marked **GENERATED** carry a "do not edit" header. Change the theme file and
re-run `theme --reapply` instead.

## 🎨 Make it yours

This is a personal setup published in the open — fork it and bend it. The theme
system is designed so you never have to touch a tool's config to restyle it.

### Add your own theme

1. Copy any file in `themes/` and fill in the values:

   ```bash
   cp themes/tokyonight-night.sh themes/my-theme.sh
   ```

   It needs a label, the core colors (`BG`, `FG`, `CURSOR`, selection), the 16-color
   palette (`PALETTE_0`–`PALETTE_15`), and the per-tool names (`STARSHIP_PALETTE`,
   `NVIM_COLORSCHEME`, `NVIM_LUALINE`). `theme.sh` **fails loudly** if anything is
   missing, so a half-finished theme can never silently leave a tool on the old colors.

2. Add a matching palette block in `starship/starship.toml`, using the same keys as
   the others (`bg`, `fg`, `muted`, `red`, `green`, `yellow`, `blue`, `magenta`,
   `cyan`, `accent`).

3. Add your Neovim colorscheme plugin to `nvim/lua/plugins/colorscheme.lua`.

4. `theme my-theme`

Ghostty ships a large theme collection — `ghostty +list-themes` — and any of those
names can go straight into `GHOSTTY_THEME`.

### Recolor the cursor and its shader

Edit the active theme file:

```bash
CURSOR="#e0af68"   # try "#7aa2f7" (blue) or "#bb9af7" (magenta)
```

Then `theme --reapply`. This recolors the Ghostty cursor **and** the animated shader
in one shot — they read from the same value.

### Other common tweaks

| Want to change | Where |
|---|---|
| Font / size | `ghostty/config` → `font-family`, `font-size` (default 15) |
| Window size | `ghostty/config` → `window-width` 180, `window-height` 45 |
| Keybindings | `ghostty/config` → the `keybind` block |
| Aliases | `bash/.bashrc` |
| Neovim plugins | `nvim/lua/plugins/` — one concern per file |
| Prompt modules | `starship/starship.toml` |

### How the shaders stay themeable

Each effect in `ghostty/shaders/effects/` keeps exactly one color constant, tagged
for the generator:

```glsl
const vec3 COL = vec3(1.0, 0.706, 0.329); // @theme:accent
```

`theme.sh` copies the chosen effect to `active_cursor.glsl` and rewrites the
`vec3(...)` on tagged lines only — `@theme:accent` for the cursor color,
`@theme:bg` for the background. The templates therefore stay valid standalone
GLSL that you can edit and test normally.

Write your own effect, drop it in `effects/`, tag its color constant, and `cfx`
picks it up automatically.

## 🔄 Syncing across machines

```bash
# Make a change — it is live immediately via symlinks
vim ghostty/config
git add . && git commit -m "feat: bump font size" && git push

# On another Mac
git pull
theme --reapply     # regenerates the gitignored shader
```

## 🛠️ Troubleshooting

<details>
<summary><strong>Config not loading</strong></summary>

```bash
./scripts/sync.sh status
ghostty +validate-config --config-file="$PWD/ghostty/config"
```

`sync.sh status` verifies every symlink points here and that the generated
artifacts exist.

</details>

<details>
<summary><strong>Colors look wrong or half-applied</strong></summary>

```bash
theme --reapply
```

Then `Cmd+Shift+,` in Ghostty and restart Neovim.

</details>

<details>
<summary><strong>Cursor effect not showing</strong></summary>

`active_cursor.glsl` is generated and gitignored, so a fresh clone has to create it:

```bash
theme --reapply
```

Then reload Ghostty with `Cmd+Shift+,`, or quit and reopen it (`Cmd+Q`).

</details>

<details>
<summary><strong><code>cross</code> does nothing</strong></summary>

macOS is blocking synthetic keystrokes. Grant Accessibility permission in System
Settings → Privacy & Security → Accessibility, or just press the four shortcuts
by hand.

</details>

<details>
<summary><strong>Icons showing as boxes</strong></summary>

```bash
brew install font-google-sans-code-nerd-font
```

Then restart your terminal.

</details>

<details>
<summary><strong>Commands not found after install</strong></summary>

```bash
source ~/.bashrc
```

Or open a new shell.

</details>

## 🤝 Contributing

Issues and pull requests are welcome — especially new themes and cursor shader
effects, since both plug in cleanly.

If you are adding a theme or a shader, `AGENTS.md` documents the conventions and
the manual validation commands (there is no test suite; validation is a handful of
`ghostty +validate-config` / `starship prompt` / `nvim --headless` checks).

## 📝 License

Free and open source — use, modify and distribute it however you like.

## 🙏 Credits

- [Tokyo Night](https://github.com/folke/tokyonight.nvim) — default color scheme
- [Ayu](https://github.com/ayu-theme/ayu-colors) — alternative color scheme
- [Gentleman.Dots](https://github.com/Gentleman-Programming/Gentleman.Dots) — cursor shader inspiration
- [LazyVim](https://www.lazyvim.org) — Neovim configuration base
- [Ghostty](https://ghostty.org) — for shipping shader support and a great theme collection

## 📬 Contact

Built by [@FelipeCarlosTech](https://github.com/FelipeCarlosTech).

If it saved you some time, a ⭐ is appreciated.

---

**Note**: macOS-only as written — it relies on Homebrew, `cmd`-based keybindings and
`osascript`. The theme system itself is plain Bash and would port to Linux with
modest changes to `install.sh`.
