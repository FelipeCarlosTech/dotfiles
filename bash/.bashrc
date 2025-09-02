# ~/.bashrc personalizado

eval "$(starship init bash)"
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(zoxide init bash)"
eval "$(fzf --bash)"
eval "$(atuin init bash)"
# Silenciar warning de zsh
export BASH_SILENCE_DEPRECATION_WARNING=1

# Si no es interactiva, no hacer nada
case $- in
*i*) ;;
*) return ;;
esac

# Historial
#HISTCONTROL=ignoreboth
#HISTSIZE=1000
#HISTFILESIZE=2000
#shopt -s histappend
shopt -s checkwinsize

# Aliases básicos
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

# Iniciar Zellij automáticamente
if command -v zellij >/dev/null 2>&1; then
  if [[ -z "$ZELLIJ" && -z "$VSCODE_TERM_PROFILE" ]]; then
    zellij attach main || zellij -s main
  fi
fi
