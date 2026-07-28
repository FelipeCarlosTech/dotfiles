# Tokyo Night — "Night" variant
#
# Single source of truth for this theme's colors across every tool.
# Applied by `scripts/theme.sh tokyonight-night`.
#
# Palette values taken verbatim from Ghostty's bundled "TokyoNight Night" theme.

THEME_LABEL="Tokyo Night · Night"

# --- Ghostty ----------------------------------------------------------------
# Name of a built-in Ghostty theme (see `ghostty +list-themes`).
# Leave empty to rely solely on the explicit palette below.
GHOSTTY_THEME="TokyoNight Night"

# --- Core colors ------------------------------------------------------------
BG="#1a1b26"
FG="#c0caf5"
# Cursor color, also used as the accent for the GLSL cursor shaders.
# Swap for "#7aa2f7" (blue) or "#bb9af7" (magenta) to restyle cursor + shaders.
CURSOR="#e0af68"
CURSOR_TEXT="#1a1b26"
SELECTION_BG="#283457"
SELECTION_FG="#c0caf5"

# --- 16-color terminal palette ---------------------------------------------
PALETTE_0="#15161e"  # black
PALETTE_1="#f7768e"  # red
PALETTE_2="#9ece6a"  # green
PALETTE_3="#e0af68"  # yellow
PALETTE_4="#7aa2f7"  # blue
PALETTE_5="#bb9af7"  # magenta
PALETTE_6="#7dcfff"  # cyan
PALETTE_7="#a9b1d6"  # white
PALETTE_8="#414868"  # bright black
PALETTE_9="#f7768e"  # bright red
PALETTE_10="#9ece6a" # bright green
PALETTE_11="#e0af68" # bright yellow
PALETTE_12="#7aa2f7" # bright blue
PALETTE_13="#bb9af7" # bright magenta
PALETTE_14="#7dcfff" # bright cyan
PALETTE_15="#c0caf5" # bright white

# --- Per-tool theme identifiers --------------------------------------------
# Must match a `[palettes.<name>]` block in starship/starship.toml
STARSHIP_PALETTE="tokyonight_night"
# Must match a colorscheme provided by a plugin in nvim/lua/plugins/colorscheme.lua
NVIM_COLORSCHEME="tokyonight-night"
NVIM_LUALINE="tokyonight"
# Requires the "Tokyo Night" theme extension in Zed
ZED_THEME="Tokyo Night"
