# Si no es interactiva, no hacer nada
case $- in
*i*) ;;
*) return ;;
esac

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

# Inicializar herramientas
# Homebrew PRIMERO: pone /opt/homebrew/bin en el PATH para que el resto se encuentre.
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(fzf --bash)"

# Aliases básicos
alias ll='ls -alF -G'
alias la='ls -A -G'
alias l='ls -CF -G'
alias grep='grep --color=auto'
alias zda='zellij da -y'
alias k='kubectl'
# Cambiar efecto de cursor de Ghostty (cfx | cfx <n|nombre>)
alias cfx="$HOME/code/felipecarlos/dotfiles/scripts/cursor-fx.sh"

# Iniciar Zellij automáticamente
# DESACTIVADO 2026-06-27: probando setup "Ghostty solo" (splits/tabs nativos).
# Para revolver a Zellij, descomenta este bloque.
# if command -v zellij >/dev/null 2>&1; then
#   if [[ -z "$ZELLIJ" && -z "$VSCODE_TERM_PROFILE" ]]; then
#     zellij attach main || zellij -s main
#     # Al salir de Zellij (p.ej. Ctrl+d en el último panel), cerrar la ventana
#     # limpiamente en vez de caer en un shell externo con la pantalla en negro.
#     exit
#   fi
# fi
