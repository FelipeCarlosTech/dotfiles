# Mis Dotfiles CLI Workflow

Stack: **Alacritty** + **Bash** + **Zellij** + **LazyVim**

Compatible con macOS.

## 🎯 **Approach: Repo como Fuente de Verdad**

Este setup usa **symlinks bidireccionales**:
- ✅ Modificas `$HOME/code/felipecarlos/dotfiles/alacritty/alacritty.toml` 
- ✅ Cambios se aplican **inmediatamente** al sistema
- ✅ `git commit` y `git push` para sincronizar
- ✅ En otra máquina: `git pull` y tienes los cambios

**NO** necesitas copiar archivos de ida y vuelta. El repo ES tu configuración.

## 🚀 Instalación Rápida

```bash
git clone <tu-repo-url> $HOME/code/felipecarlos/dotfiles
cd $HOME/code/felipecarlos/dotfiles
chmod +x install.sh scripts/*.sh
./install.sh
