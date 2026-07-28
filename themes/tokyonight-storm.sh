# Tokyo Night — "Storm" variant (lighter, bluer background than Night)
#
# Single source of truth for this theme's colors across every tool.
# Applied by `scripts/theme.sh tokyonight-storm`.
#
# Palette values taken verbatim from Ghostty's bundled "TokyoNight Storm" theme.

THEME_LABEL="Tokyo Night · Storm"

# --- Ghostty ----------------------------------------------------------------
GHOSTTY_THEME="TokyoNight Storm"

# --- Core colors ------------------------------------------------------------
BG="#24283b"
FG="#c0caf5"
CURSOR="#e0af68"
CURSOR_TEXT="#1d202f"
SELECTION_BG="#364a82"
SELECTION_FG="#c0caf5"

# --- 16-color terminal palette ---------------------------------------------
PALETTE_0="#1d202f"  # black
PALETTE_1="#f7768e"  # red
PALETTE_2="#9ece6a"  # green
PALETTE_3="#e0af68"  # yellow
PALETTE_4="#7aa2f7"  # blue
PALETTE_5="#bb9af7"  # magenta
PALETTE_6="#7dcfff"  # cyan
PALETTE_7="#a9b1d6"  # white
PALETTE_8="#4e5575"  # bright black
PALETTE_9="#f7768e"  # bright red
PALETTE_10="#9ece6a" # bright green
PALETTE_11="#e0af68" # bright yellow
PALETTE_12="#7aa2f7" # bright blue
PALETTE_13="#bb9af7" # bright magenta
PALETTE_14="#7dcfff" # bright cyan
PALETTE_15="#c0caf5" # bright white

# --- Per-tool theme identifiers --------------------------------------------
STARSHIP_PALETTE="tokyonight_storm"
NVIM_COLORSCHEME="tokyonight-storm"
NVIM_LUALINE="tokyonight"
# Requires the "Tokyo Night" theme extension in Zed
ZED_THEME="Tokyo Night Storm"
