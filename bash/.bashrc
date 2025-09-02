# ~/.bashrc personalizado

eval "$(/opt/homebrew/bin/brew shellenv)"
# Silenciar warning de zsh
export BASH_SILENCE_DEPRECATION_WARNING=1

# Si no es interactiva, no hacer nada
case $- in
*i*) ;;
*) return ;;
esac

# Historial
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

# Prompt básico
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

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
