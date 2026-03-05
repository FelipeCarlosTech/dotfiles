# AGENTS.md

Guidelines for AI coding agents working in this dotfiles repository.

## Repository Overview

Personal macOS dotfiles using **symlinks as source of truth**. The repo IS the live
configuration — files are symlinked to `~/.config/` and `~/`, so every edit is
immediately active on the system. There is no build step or compilation.

Languages/formats: Bash shell scripts, Lua (Neovim/LazyVim), TOML, KDL, GLSL, JSON.

## Commands

```bash
# Installation
./install.sh                  # Full install (both terminals, creates symlinks, installs tools)
./install.sh --ghostty        # Ghostty-only install
./install.sh --alacritty      # Alacritty-only install
./scripts/sync.sh status      # Verify all symlinks are intact
./scripts/sync.sh git-status  # Show repo status and recent commits
./scripts/sync.sh backup      # Create timestamped backup of current configs
./scripts/prepare.sh          # Copy existing system configs into repo (pre-install)

# Formatting — Lua files (StyLua, config in nvim/stylua.toml)
stylua nvim/                          # Format all Lua files
stylua nvim/lua/plugins/ui.lua        # Format a single file
stylua --check nvim/                  # Check without modifying

# Linting — Shell scripts (ShellCheck, not enforced by CI but recommended)
shellcheck install.sh scripts/*.sh bash/.bashrc

# Testing — No test suite. Validation is manual:
./scripts/sync.sh status             # Verify symlinks
bash -n install.sh                   # Syntax-check a shell script
bash -n bash/.bashrc
```

### Applying Changes

- **Config files** (Ghostty, Alacritty, Starship, Zellij): restart terminal/tool.
- **Bash config** (`bash/.bashrc`): `source ~/.bashrc` or restart terminal.
- **Neovim config** (`nvim/`): restart Neovim; plugins auto-install via lazy.nvim.

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

- **Shebang**: `#!/bin/bash` (requires Bash 5.2+ via Homebrew)
- **Strict mode**: Use `set -e` in scripts that must fail fast (install, prepare).
  Omit in scripts that use `case` dispatch (sync.sh).
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

### TOML (Starship, Alacritty, StyLua)

- Standard TOML formatting with `[section]` headers.
- Hex color strings: `"#0A0E14"`.
- Inline tables for compact values: `{ columns = 150, lines = 30 }`.
- Schema references at top when available.

### KDL (Zellij)

- **Indent**: 4 spaces.
- `//` comments.
- Plugin config blocks use aligned key-value pairs for readability.
- Keybind format: `bind "key" { Action; }` with `;` separating multiple actions.

### GLSL (Ghostty Shaders)

- 4-space indent, `//` comments, standard GLSL conventions.

### Ghostty Config

- Flat `key = value` with spaces around `=`, kebab-case keys, `#` section comments.

## Theming

All tools use **Ayu Dark** (bg=#0A0E14, fg=#B3B1AD, cursor=#FFB454). When modifying
theme values, maintain consistency across: `ghostty/config`, `alacritty/alacritty.toml`,
`starship/starship.toml` (palette at line 29), `zellij/config.kdl`,
`nvim/lua/plugins/colorscheme.lua`.

Commented-out **Carbonfox/Nightfox** backup blocks exist in multiple config files.
These are intentional — preserve them when editing.

## Architecture Rules

1. **Symlinks are the deployment mechanism.** Never copy files to system locations;
   always symlink from this repo. The `install.sh` script handles this.
2. **Idempotent scripts.** `install.sh` is safe to run repeatedly. It checks for
   existing symlinks and creates timestamped backups of real files before overwriting.
3. **No CI/CD.** There are no GitHub Actions, Makefiles, or automated pipelines.
   Validation is manual via `./scripts/sync.sh status`.
4. **No Cursor/Copilot rules.** The only AI context file is `CLAUDE.md` (gitignored).
5. **Bilingual comments.** Code comments and user-facing messages may be in English
   or Spanish. Follow the existing pattern in each file.

## Git Conventions

- **Commit messages**: Imperative mood, present tense. Start with a verb (Add, Fix,
  Update, Remove, Disable, Change). No conventional-commit prefixes.
  Examples: `Add Java and testing support for QA automation`,
  `Fix explorer: use snacks.nvim config instead of neo-tree`.
- **No force push.** This is a personal config repo synced across machines.

## Key Files

| Path | Purpose |
|------|---------|
| `install.sh` | Main installer — symlinks + tool installation |
| `scripts/sync.sh` | Symlink verification, git status, backups |
| `scripts/prepare.sh` | Pre-install: copy existing configs to repo |
| `bash/.bashrc` | Shell config with Zellij auto-start (line 42) |
| `nvim/lua/config/keymaps.lua` | Custom keymaps (Ctrl+s save) |
| `nvim/lua/plugins/colorscheme.lua` | Ayu Dark theme config |
| `nvim/lua/plugins/ui.lua` | Lualine, incline, dashboard |
| `ghostty/config` | Primary terminal config |
| `zellij/config.kdl` | Multiplexer keybindings and theme |

## Known Issue

`DOTFILES_DIR` path is inconsistent: `install.sh` uses `$HOME/code/dotfiles` while
`sync.sh` and `prepare.sh` use `$HOME/code/felipecarlos/dotfiles`. Be aware of this
when modifying path references in scripts.
