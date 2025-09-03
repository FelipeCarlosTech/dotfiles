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

### 📚 atuin - Historial Mágico
Historial de comandos con contexto, sincronización y búsqueda potente.

**Instalación (macOS):**
```bash
# Instalación automática (incluye bash-preexec):
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# O manual:
brew install atuin
# Instalar bash-preexec (requerido para bash):
curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ~/.bash-preexec.sh
echo '[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh' >> ~/.bashrc
# Inicializar atuin:
echo 'eval "$(atuin init bash)"' >> ~/.bashrc
```

**Configuración:**
```bash
atuin register    # Crear cuenta para sincronización (opcional)
atuin import      # Importar historial existente
```

**Uso:**
```bash
Ctrl+R           # Búsqueda interactiva de historial
atuin search ls  # Buscar comandos que contengan "ls"
atuin stats      # Estadísticas de uso
```

### ⚡ bash-preexec - Hooks para Bash
Proporciona hooks preexec/precmd para Bash (requerido por atuin).

**Instalación:**
```bash
# Automática con atuin, o manual:
curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ~/.bash-preexec.sh
echo '[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh' >> ~/.bashrc
```

**Nota:** Debe ser la última cosa importada en tu `.bashrc`.
