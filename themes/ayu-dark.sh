# Ayu Dark — the previous default, kept as a first-class switchable theme.
#
# Single source of truth for this theme's colors across every tool.
# Applied by `scripts/theme.sh ayu-dark`.

THEME_LABEL="Ayu Dark"

# --- Ghostty ----------------------------------------------------------------
# Ghostty ships no Ayu Dark theme, so the explicit palette below is authoritative.
GHOSTTY_THEME=""

# --- Core colors ------------------------------------------------------------
BG="#0A0E14"
FG="#B3B1AD"
CURSOR="#FFB454"
CURSOR_TEXT="#0A0E14"
SELECTION_BG="#253340"
SELECTION_FG="#B3B1AD"

# --- 16-color terminal palette ---------------------------------------------
PALETTE_0="#01060E"  # black
PALETTE_1="#EA6C73"  # red
PALETTE_2="#91B362"  # green
PALETTE_3="#F9AF4F"  # yellow
PALETTE_4="#53BDFA"  # blue
PALETTE_5="#FAE994"  # magenta
PALETTE_6="#90E1C6"  # cyan
PALETTE_7="#C7C7C7"  # white
PALETTE_8="#686868"  # bright black
PALETTE_9="#F07178"  # bright red
PALETTE_10="#C2D94C" # bright green
PALETTE_11="#FFB454" # bright yellow
PALETTE_12="#59C2FF" # bright blue
PALETTE_13="#FFEE99" # bright magenta
PALETTE_14="#95E6CB" # bright cyan
PALETTE_15="#FFFFFF" # bright white

# --- Per-tool theme identifiers --------------------------------------------
STARSHIP_PALETTE="ayu_dark"
NVIM_COLORSCHEME="ayu-dark"
NVIM_LUALINE="ayu"
