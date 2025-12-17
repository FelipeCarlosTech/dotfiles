# Si no es interactiva, no hacer nada
case $- in
*i*) ;;
*) return ;;
esac

# Cargar ble.sh temprano (solo en Ghostty, solo en shells interactivos)
[[ $- == *i* ]] && [[ -n "$GHOSTTY_RESOURCES_DIR" ]] && source ~/.local/share/blesh/ble.sh --noattach

# Variables de entorno
export BASH_SILENCE_DEPRECATION_WARNING=1
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Configuración del historial de bash
export HISTSIZE=50000
export HISTFILESIZE=100000
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%F %T "
shopt -s histappend

# Configuraciones del shell
shopt -s checkwinsize

export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window down:3:hidden:wrap
  --bind '?:toggle-preview'
  --height=80%
  --layout=reverse
  --info=inline
  --tiebreak=index
  --no-sort
"

# Inicializar atuin solo en Ghostty (requiere ble.sh)
if [ -n "$GHOSTTY_RESOURCES_DIR" ]; then
  if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init bash)"
  fi
fi

# Inicializar herramientas
eval "$(starship init bash)"
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(zoxide init bash)"
eval "$(fzf --bash)"

# Aliases básicos
alias ll='ls -alF -G'
alias la='ls -A -G'
alias l='ls -CF -G'
alias grep='grep --color=auto'
alias zda='zellij da -y'
alias k='kubectl'

# Iniciar Zellij automáticamente
if command -v zellij >/dev/null 2>&1; then
  if [[ -z "$ZELLIJ" && -z "$VSCODE_TERM_PROFILE" ]]; then
    zellij attach main || zellij -s main
  fi
fi

# Attach ble.sh al final (solo en Ghostty, solo en shells interactivos)
[[ $- == *i* ]] && [[ -n "$GHOSTTY_RESOURCES_DIR" ]] && ble-attach
