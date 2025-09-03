# ~/.bashrc personalizado

# Si no es interactiva, no hacer nada
case $- in
*i*) ;;
*) return ;;
esac

# Variables de entorno
export BASH_SILENCE_DEPRECATION_WARNING=1
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Configuraciones del shell
shopt -s checkwinsize

[[ -f "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/profile.d/bash-preexec.sh" ]] && source "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/profile.d/bash-preexec.sh"

# Inicializar herramientas (DESPUÉS de bash-preexec)
eval "$(starship init bash)"
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(zoxide init bash)"
eval "$(fzf --bash)"
eval "$(atuin init bash)"

# Aliases básicos
alias ll='ls -alF -G'
alias la='ls -A -G'
alias l='ls -CF -G'
alias grep='grep --color=auto'

# Iniciar Zellij automáticamente
if command -v zellij >/dev/null 2>&1; then
  if [[ -z "$ZELLIJ" && -z "$VSCODE_TERM_PROFILE" ]]; then
    zellij attach main || zellij -s main
  fi
fi
