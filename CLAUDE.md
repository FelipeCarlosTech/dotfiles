# CLAUDE.md

Guidance for Claude Code when working in this repository.

> Code style, per-language conventions, and the full command reference live in
> **`AGENTS.md`**. Read it before editing. This file carries only the essentials
> plus the traps that are easy to fall into here.

## Repository Overview

Personal macOS dotfiles for a **Ghostty + Bash + LazyVim + Starship** setup.

The architectural principle is **symlinks as source of truth**: the repository IS
the live configuration, not a backup. Files are symlinked into `~/.config/` and
`~/`, so editing a file here changes the running system immediately, and editing
through the symlink shows up in `git status`.

### Current state (as of 2026-07-27)

- **Zellij: removed.** Replaced by Ghostty's native splits and tabs. Do not
  reintroduce it, and do not suggest `zellij` commands.
- **Alacritty: removed.** Ghostty is the only terminal.
- **Zed: removed.** Neovim is the only editor. Do not reintroduce `zed/`.
- **atuin: never installed.** Ignore any older reference to it.
- **Theme: Tokyo Night (Night)** by default, via a central switchable system.

### Symlinks created by `install.sh`

| Repo path | System path |
|---|---|
| `ghostty/` | `~/.config/ghostty/` |
| `nvim/` | `~/.config/nvim/` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `bash/.bashrc` | `~/.bashrc` |

## Theming — the central mechanism

**Never hardcode a color in a tool's config.** All colors come from one file per
theme in `themes/`. This is the most important rule in the repo.

```
themes/<name>.sh          SOURCE OF TRUTH: palette + per-tool theme identifiers
        │
        └── scripts/theme.sh <name>
                ├── GENERATES  ghostty/theme.conf                 (included from ghostty/config)
                ├── GENERATES  ghostty/shaders/active_cursor.glsl  (gitignored)
                ├── GENERATES  nvim/lua/config/theme.lua
                └── PATCHES    starship/starship.toml   the `palette = "..."` line
```

- Available themes: `tokyonight-night`, `tokyonight-storm`, `ayu-dark`.
- State markers: `.theme` and `.cursor-fx` at the repo root (both committed).
- Files with a `GENERADO por scripts/theme.sh` header are **never** hand-edited.
- A hardcoded hex outside `themes/*.sh` and starship's `[palettes.*]` is a bug.
- Adding a theme also requires a starship palette block and an nvim colorscheme
  plugin — see AGENTS.md for the checklist.

### Shader tagging

Cursor shaders in `ghostty/shaders/effects/` keep exactly one themed constant,
tagged `// @theme:accent` or `// @theme:bg`. `theme.sh` rewrites the `vecN(...)`
on tagged lines only, anchored on the first `=`. Never put a `vecN(...)` inside a
tagged line's comment — it will be captured by the rewrite.

## Common Commands

```bash
./install.sh                          # Symlinks + tools + apply theme
./install.sh --theme ayu-dark         # Install with a specific theme

theme                                 # List themes / show active   (scripts/theme.sh)
theme tokyonight-night                # Apply everywhere
theme --reapply                       # Regenerate artifacts

cfx                                   # List cursor effects         (scripts/cursor-fx.sh)
cfx bloom                             # Switch effect (auto-tinted to the theme)

cross                                 # 2x2 split layout            (scripts/ghostty-cross.sh)

./scripts/sync.sh status              # Symlinks + theme + artifacts
./scripts/sync.sh backup              # Timestamped backup
```

## Validation (there is no test suite)

```bash
ghostty +validate-config --config-file="$PWD/ghostty/config"     # also checks theme.conf
STARSHIP_CONFIG="$PWD/starship/starship.toml" starship prompt    # palette keys must resolve
nvim --headless -c 'lua print(vim.g.colors_name)' -c qa          # colorscheme applied?
./scripts/sync.sh status
bash -n install.sh
```

## Traps

1. **`ghostty +validate-config` emits a screen clear.** Redirect it
   (`>/dev/null 2>&1`) when running it mid-script, or it wipes earlier output.
2. **Ghostty keybinds are one action each.** Ghostty 1.3.1 supports trigger
   *sequences* (`ctrl+a>d`) but not action chaining, and has no layout files. A
   2×2 cross needs four keystrokes or the `cross` script.
3. **Never hardcode the repo path in a script.** Derive it:
   `DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"`.
   `install.sh` used to hardcode the wrong path and broke every fresh clone.
4. **`active_cursor.glsl` is gitignored.** A fresh clone needs
   `theme --reapply` before Ghostty finds it.
5. **`theme.sh` uses only bash builtins + `awk`** on purpose, so a fresh machine
   can theme itself before extra tools exist. Don't add dependencies to it.
6. **Editing through `~/.config/...` edits the repo.** Expect `git status` changes.

## Key Configuration Details

### Ghostty (`ghostty/config`)

- Font: Google Sans Code NF, size 15
- Window: 180×45 characters, decorations on, 10px/5px padding
- Shell: `/opt/homebrew/bin/bash` with shell integration, `no-cursor` feature
- Cursor: block, native blink off (the `9-smearbreathe` shader emits its own)
- Shader: `shaders/active_cursor.glsl`, `custom-shader-animation = always`
- Keybinds: splits (`cmd+d`, `cmd+shift+d`), vim navigation (`cmd+alt+hjkl`),
  resize (`cmd+ctrl+hjkl`), equalize (`cmd+ctrl+r`), tabs (`cmd+t`, `cmd+shift+hl`)

### Bash (`bash/.bashrc`)

- History: 50k lines, timestamps, no duplicates, append mode
- Tool init order matters: **Homebrew first** (puts `/opt/homebrew/bin` on PATH),
  then starship, zoxide, fzf
- fzf `Ctrl+R`: 80% height, reverse layout, hidden preview
- Aliases: `ll`/`la`/`l`, `k` (kubectl), `theme`, `cfx`, `cross`

### Neovim (LazyVim)

- Colorscheme and lualine theme both come from `require("config.theme")`
- `nvim/lua/plugins/colorscheme.lua` declares every switchable colorscheme plugin
- Custom keymap: `Ctrl+s` save with notification (`lua/config/keymaps.lua`)
- Options: `scrolloff = 8`, `linebreak = true`

### Starship (`starship/starship.toml`)

- All palettes live in this file; module formats reference **semantic keys**
  (`fg:blue`), never hex
- Palette keys every theme must define: `bg`, `fg`, `muted`, `red`, `green`,
  `yellow`, `blue`, `magenta`, `cyan`, `accent`

## Workflow

1. Edit files directly in this repo — changes apply immediately via symlinks
2. For colors, edit `themes/<name>.sh` and run `theme --reapply`
3. Validate with the commands above
4. Commit: imperative mood, no conventional-commit prefixes, no AI attribution
