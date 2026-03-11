# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed with GNU Stow. It contains configuration files for shell environments (zsh), terminal emulators (Ghostty), multiplexers (tmux), editors (Neovim), and macOS-specific tools (AeroSpace, Kanata, SketchyBar).

## Installation and Setup Commands

```bash
# Install all dotfiles
./setup.sh

# Manual installation with stow
stow --dotfiles -t ~ .

# Dry-run to preview what stow will do
stow --dotfiles -t ~ --simulate .

# Link a single configuration module
stow --dotfiles -t ~ dot-config/nvim
```

The setup script automatically:
- Installs dependencies via Homebrew (stow, jq, curl)
- Installs required fonts (JetBrainsMono Nerd Font, sketchybar-app-font, SF Pro)
- Installs dotfiles using stow
- Downloads antigen (zsh plugin manager) to `~/.config/antigen/antigen.zsh`
- Clones tpm (tmux plugin manager) to `~/.tmux/plugins/tpm`

### Additional macOS Tools (install separately)

```bash
# Window manager and bar
brew install --cask nikitabobko/tap/aerospace
brew tap FelixKratz/formulae
brew install sketchybar borders

# Start services
brew services start sketchybar
```

## Architecture and Structure

### Stow-Based Linking System

This repository uses GNU Stow's `--dotfiles` feature to manage symlinks. Files/directories prefixed with `dot-` get renamed with a `.` prefix when linked to `$HOME`.

**Key mechanisms:**
- `.stow-local-ignore`: Defines files that stow should skip (git metadata, README, scripts, cache files like `*.zwc`)
- `.stowrc`: Stow configuration (if needed)

### Directory Layout

```
.
├── dot-config/          # Maps to ~/.config/
│   ├── aerospace/       # macOS window manager
│   ├── borders/         # macOS window borders
│   ├── ghostty/         # Terminal emulator
│   ├── kanata/          # Keyboard remapper
│   ├── nvim/            # Neovim configuration (LazyVim)
│   ├── sketchybar/      # macOS menu bar
│   ├── starship/        # Prompt configuration
│   └── tmux/            # Tmux configuration
├── dot-zshrc            # Maps to ~/.zshrc (single-file zsh config)
└── setup.sh             # Installation orchestrator
```

### Shell Configuration

All zsh configuration lives in `dot-zshrc`. It loads:
- Antigen plugin manager with bundles: `git` (omz), `zsh-syntax-highlighting`, `zsh-autosuggestions`, `zsh-you-should-use`, `fzf-tab`
- Starship prompt and zoxide
- Custom aliases (overrides omz git `gc` alias)

Antigen cache is stored in `${XDG_CACHE_HOME:-$HOME/.cache}/antigen`.

### Tmux Configuration

`dot-config/tmux/tmux.conf` configures:
- Custom prefix: `Ctrl-Space`
- TPM plugins: catppuccin theme, vim-tmux-navigator, tmux-which-key, tmux-sensible, tmux-fzf

### SketchyBar Configuration

`dot-config/sketchybar/` provides a customized macOS menu bar with:

**Visual Style:**
- Floating bar with margins, rounded corners (12px), and shadow
- Catppuccin Mocha color scheme
- Pill-style item backgrounds

**Items (left to right):**
- **Spaces**: AeroSpace workspace indicators with app icons
- **Front App**: Currently focused application
- **Media** (center): Spotify now playing with track/artist
- **CPU**: CPU usage percentage
- **Memory**: RAM usage percentage
- **Volume**: System volume with SF Symbol icons
- **WiFi**: Network connection status
- **Battery**: Battery percentage and charging status
- **Weather**: Current temperature from wttr.in
- **Calendar**: Date and time

**File Structure:**
```
sketchybar/
├── sketchybarrc      # Main config, sources all components
├── bar.sh            # Bar appearance (floating style)
├── colors.sh         # Catppuccin Mocha palette
├── defaults.sh       # Default item styling
├── items/            # Item definitions
│   ├── spaces.sh     # Workspace indicators
│   ├── front_app.sh  # Active app display
│   ├── media.sh      # Spotify now playing
│   ├── cpu.sh        # CPU usage
│   ├── memory.sh     # RAM usage
│   ├── volume.sh     # Volume control
│   ├── wifi.sh       # Network status
│   ├── battery.sh    # Battery indicator
│   ├── weather.sh    # Weather display
│   └── calendar.sh   # Date/time
└── plugins/          # Scripts that update items
```

**Required Fonts:**
- `JetBrainsMono Nerd Font Propo` - Main font for labels
- `sketchybar-app-font` - Application icons
- `SF Pro` - SF Symbols for system icons

**Reloading:** Kill and restart sketchybar to apply config changes:
```bash
killall sketchybar; sketchybar &
```

### AeroSpace Configuration

`dot-config/aerospace/aerospace.toml` configures:
- Window tiling with 6px gaps (56px top gap for sketchybar)
- Vim-style navigation: `alt-h/j/k/l` to focus, `alt-shift-h/j/k/l` to move
- Workspaces: `alt-a/s/d/f/g` for workspaces 1-5
- Quick launch: `alt-t` (terminal), `alt-b` (browser), `alt-m` (music)
- Service mode: `alt-shift-;` then `esc` to reload config

## Validation and Testing

```bash
# Validate zsh syntax
zsh -n dot-zshrc

# Test tmux config
tmux -f ~/.config/tmux/tmux.conf

# Test Neovim health
nvim --clean +checkhealth +qall

# Test sketchybar config
sketchybar --query bar

# Reload aerospace config
aerospace reload-config
```

## Commit Conventions

Follow Conventional Commits format: `type(scope): summary`

Common scopes: `nvim`, `zsh`, `tmux`, `ghostty`, `sketchybar`, `aerospace`, `setup`

## Important Notes

- **Cache Files**: Files matching `*.zwc` are zsh compiled files and should remain gitignored
- **Secrets**: Never commit machine-specific secrets; use `~/.localrc` or similar untracked files
- **Emacs Mode**: Zsh is configured to use emacs keybindings (not vi mode) with `bindkey -e`
