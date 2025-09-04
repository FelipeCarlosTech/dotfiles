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

```

## 🔌 Plugins Esenciales

### Instalación Automática
El script `install.sh` instala automáticamente todos los plugins. Para instalación manual:

### 🚀 zoxide - Smart CD
Navegación inteligente entre directorios, un `cd` con superpoderes.

**Instalación (macOS):**
```bash
brew install zoxide
# Añadir a ~/.bashrc:
eval "$(zoxide init bash)"
```

**Uso:**
```bash
z project     # Salta a cualquier directorio que contenga "project"
zi           # Selector interactivo de directorios
```

### 🔍 fzf - Fuzzy Finder
Búsqueda difusa de archivos y comandos en terminal.

**Instalación (macOS):**
```bash
brew install fzf
# Instalar integraciones de teclado y completions:
$(brew --prefix)/opt/fzf/install
```

**Uso:**
```bash
Ctrl+R       # Buscar en historial de comandos
Ctrl+T       # Buscar archivos/directorios
Alt+C        # Cambiar a directorio encontrado
```

