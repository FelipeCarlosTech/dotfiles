# AGENTS.md

Guidelines for AI coding agents working in this dotfiles repository.

## Repository Overview

Personal macOS dotfiles using **symlinks as source of truth**. The repo IS the live
configuration — files are symlinked to `~/.config/` and `~/`, so every edit is
immediately active on the system. There is no build step or compilation.

Stack: **Ghostty** + **Bash** + **LazyVim** + **Starship** + **Zed**. Zellij and
Alacritty were removed on 2026-07-27 (Ghostty's native splits/tabs replaced Zellij).

Languages/formats: Bash shell scripts, Lua (Neovim/LazyVim), TOML, GLSL, JSON.

## Commands

```bash
# Installation
./install.sh                          # Full install (symlinks + tools + apply theme)
./install.sh --theme tokyonight-storm # Install and apply a specific theme
./scripts/prepare.sh                  # Copy existing system configs into repo (pre-install)

# Maintenance
./scripts/sync.sh status              # Verify symlinks, active theme, generated artifacts
./scripts/sync.sh git-status          # Show repo status and recent commits
./scripts/sync.sh backup              # Create timestamped backup of current configs

# Theming (see "Theming" below — this is the central mechanism)
./scripts/theme.sh                    # List themes, show the active one
./scripts/theme.sh tokyonight-night   # Apply a theme across every tool
./scripts/theme.sh --reapply          # Regenerate artifacts for the active theme
./scripts/cursor-fx.sh bloom          # Switch the Ghostty cursor shader effect
./scripts/ghostty-cross.sh            # Build a 2x2 split layout in Ghostty

# Formatting — Lua files (StyLua, config in nvim/stylua.toml)
stylua nvim/                          # Format all Lua files
stylua --check nvim/                  # Check without modifying

# Linting — Shell scripts (ShellCheck, not enforced by CI but recommended)
shellcheck install.sh scripts/*.sh bash/.bashrc

# Testing — No test suite. Validation is manual:
ghostty +validate-config --config-file="$PWD/ghostty/config"   # Validates theme.conf too
STARSHIP_CONFIG="$PWD/starship/starship.toml" starship prompt  # Palette keys must resolve
nvim --headless -c 'lua print(vim.g.colors_name)' -c qa        # Colorscheme applied?
./scripts/sync.sh status                                       # Symlinks + artifacts
bash -n install.sh                                             # Syntax-check a shell script
```

Note: `ghostty +validate-config` emits a screen clear. Redirect its output
(`>/dev/null 2>&1`) when running it mid-script, or it will wipe earlier output.

### Applying Changes

- **Ghostty / Starship**: reload Ghostty with `Cmd+Shift+,`; `source ~/.bashrc` for the prompt.
- **Bash config** (`bash/.bashrc`): `source ~/.bashrc` or restart terminal.
- **Neovim config** (`nvim/`): restart Neovim; plugins auto-install via lazy.nvim.
- **Zed**: picks up `settings.json` changes live.

## Theming

**All colors flow from one file per theme in `themes/`.** Never hardcode a color in
a tool's config — that is exactly the mess this system replaced.

```
themes/<name>.sh          SOURCE OF TRUTH: palette + per-tool theme identifiers
        │
        └── scripts/theme.sh <name>
                ├── GENERATES  ghostty/theme.conf                  (included from ghostty/config)
                ├── GENERATES  ghostty/shaders/active_cursor.glsl   (gitignored; effect + accent)
                ├── GENERATES  nvim/lua/config/theme.lua            (colorscheme + lualine names)
                ├── PATCHES    starship/starship.toml               the `palette = "..."` line
                └── PATCHES    zed/settings.json                    the `"dark": "..."` line
```

State markers at the repo root: `.theme` (active theme) and `.cursor-fx` (active
cursor effect). Both are committed so a fresh clone reproduces the same look.

### Adding a theme

1. Copy an existing `themes/<name>.sh` and fill in every variable. `theme.sh`
   fails loudly if any of `THEME_LABEL`, `BG`, `FG`, `CURSOR`, `CURSOR_TEXT`,
   `SELECTION_BG`, `SELECTION_FG`, `PALETTE_0`–`PALETTE_15`, `STARSHIP_PALETTE`,
   `NVIM_COLORSCHEME`, `NVIM_LUALINE`, or `ZED_THEME` is missing.
2. Add a matching `[palettes.<STARSHIP_PALETTE>]` block in `starship/starship.toml`
   with the **same key set** as the existing palettes (`bg`, `fg`, `muted`, `red`,
   `green`, `yellow`, `blue`, `magenta`, `cyan`, `accent`).
3. Add the colorscheme plugin to `nvim/lua/plugins/colorscheme.lua`.
4. Run `./scripts/theme.sh <name>` and validate with the commands above.

### Rules

- Starship module formats reference **semantic palette keys** (`fg:blue`), never hex.
- Nvim reads `require("config.theme")` for both colorscheme and lualine theme.
- GLSL shaders keep exactly one themed constant, tagged `// @theme:accent` or
  `// @theme:bg`. `theme.sh` rewrites the `vecN(...)` on tagged lines only, anchored
  on the first `=`. Do not put a `vecN(...)` in a tagged line's comment.
- Ghostty built-in theme names come from `ghostty +list-themes`; the explicit
  palette in `theme.conf` is written alongside it so the result is pinned.

## Code Style

### Lua (Neovim — `nvim/`)

Enforced by StyLua (`nvim/stylua.toml`):
- **Indent**: 2 spaces
- **Column width**: 120 characters
- **Quotes**: double quotes (StyLua default)

LazyVim conventions:
- Every plugin file returns a table: `return { { "author/plugin", opts = {} } }`
- Config overrides live in `lua/config/` (options, keymaps, autocmds, lazy bootstrap).
- Plugin specs live in `lua/plugins/`, one concern per file.
- Use `opts = {}` for declarative config; use `config = function() ... end` only when
  imperative setup is required (e.g., `require("incline").setup({})`).
- Prefer `vim.keymap.set()` over `vim.api.nvim_set_keymap()` for new keymaps.
- Use `local opt = vim.opt` shorthand in options files.
- Error handling: wrap risky calls in `pcall`; report via `vim.notify(msg, level)`.
- Use `-- stylua: ignore` to suppress formatting on specific lines when alignment
  matters (e.g., dashboard key tables).

Plugin documentation header style (use in `lua/plugins/` files):
```lua
-- Plugin: plugin-name
-- URL: https://github.com/author/plugin-name
-- Description: One-line description of what it does.
```

### Shell Scripts (Bash)

- **Shebang**: `#!/usr/bin/env bash` (requires Bash 5.2+ via Homebrew)
- **Strict mode**: `set -euo pipefail` in new scripts; `set -e` in the older
  installers. Omit in scripts that use `case` dispatch (sync.sh).
- **Repo path**: derive it from the script's own location, never hardcode it:
  `DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"`
- **Indent**: 2 spaces
- **Variables**: `UPPER_SNAKE_CASE` for exported/global, `lower_snake_case` for local.
  Always declare locals with `local`.
- **Functions**: `lower_snake_case`, defined before use.
- **Conditionals**: `[ -e "$path" ]` for file tests; `[[ ]]` for string/pattern matching.
- **Error suppression**: `2>/dev/null || true` for optional commands that may fail.
- **Tool detection**: `command -v tool >/dev/null 2>&1`.
- **Output style**: Emoji prefixes for section headers, `✓`/`✗` for success/failure,
  `→` for item listing. User-facing messages may be in Spanish.
- **Quoting**: Always double-quote variables: `"$var"`, `"$(command)"`.
- **No new runtime deps**: `theme.sh` deliberately uses only bash builtins + `awk`,
  so a fresh machine can apply a theme before any extra tool is installed.

### TOML (Starship, StyLua)

- Standard TOML formatting with `[section]` headers.
- Hex colors appear **only** inside `[palettes.*]` blocks. Everywhere else, use a
  semantic palette key.
- Schema references at top when available.

### GLSL (Ghostty Shaders)

- 4-space indent, `//` comments, standard GLSL conventions.
- One themed constant per file, tagged `// @theme:accent` / `// @theme:bg`.
- Files in `shaders/effects/` are templates; `active_cursor.glsl` is generated.

### Ghostty Config

- Flat `key = value` with spaces around `=`, kebab-case keys, `#` section comments.
- Colors belong in the generated `theme.conf`, never in `config`.
- One `keybind` maps one trigger to exactly ONE action. Ghostty 1.3.1 supports
  trigger *sequences* (`ctrl+a>d`) but not action chaining, and has no layout files.

## Architecture Rules

1. **Symlinks are the deployment mechanism.** Never copy files to system locations;
   always symlink from this repo. The `install.sh` script handles this.
2. **Idempotent scripts.** `install.sh` is safe to run repeatedly. It checks for
   existing symlinks and creates timestamped backups of real files before overwriting.
3. **Single source of truth for color.** See "Theming". A hardcoded hex outside
   `themes/*.sh` and `[palettes.*]` is a bug.
4. **Generated files are never hand-edited.** They carry a "GENERADO por
   scripts/theme.sh" header. Change the theme file and re-run instead.
5. **No CI/CD.** There are no GitHub Actions, Makefiles, or automated pipelines.
   Validation is manual — see the Testing commands above.
6. **No Cursor/Copilot rules.** The only AI context file is `CLAUDE.md` (gitignored).
7. **Bilingual comments.** Code comments and user-facing messages may be in English
   or Spanish. Follow the existing pattern in each file.

## Git Conventions

- **Commit messages**: [Conventional Commits](https://www.conventionalcommits.org).
  `<type>: <imperative summary>` — types used here: `feat`, `fix`, `refactor`,
  `docs`, `chore`.
  Examples: `feat: add switchable theme system`,
  `fix: resolve dotfiles path from script location`,
  `refactor: remove Zed editor from the setup`.
  Commits before 2026-07-27 use bare imperative summaries without a type prefix.
- **No AI attribution.** No `Co-Authored-By` or generated-by trailers.
- **No force push.** This is a personal config repo synced across machines.

## Key Files

| Path | Purpose |
|------|---------|
| `themes/*.sh` | **Source of truth** for each theme's colors |
| `scripts/theme.sh` | Applies a theme across every tool; generates artifacts |
| `scripts/cursor-fx.sh` | Switches the Ghostty cursor shader effect |
| `scripts/ghostty-cross.sh` | Builds a 2x2 Ghostty split layout via System Events |
| `install.sh` | Main installer — symlinks + tools + theme |
| `scripts/sync.sh` | Symlink verification, theme status, git status, backups |
| `scripts/prepare.sh` | Pre-install: copy existing configs to repo |
| `bash/.bashrc` | Shell config; aliases `theme`, `cfx`, `cross` |
| `ghostty/config` | Terminal config (no colors — includes `theme.conf`) |
| `ghostty/theme.conf` | GENERATED colors |
| `ghostty/shaders/effects/` | Cursor shader templates |
| `nvim/lua/config/theme.lua` | GENERATED colorscheme + lualine names |
| `nvim/lua/plugins/colorscheme.lua` | Declares every switchable colorscheme plugin |
| `nvim/lua/plugins/ui.lua` | Lualine, incline, dashboard |
| `starship/starship.toml` | Prompt; all palettes live here |
| `zed/settings.json` | Zed editor settings |
