# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed with GNU Stow. It contains configuration files for shell environments (zsh), terminal emulators (Ghostty), multiplexers (tmux), editors (Neovim), and macOS-specific tools (AeroSpace, Karabiner, SketchyBar).

## Installation and Setup Commands

```bash
# Install all dotfiles (desktop mode - includes macOS-specific configs)
./setup.sh

# Install for headless/server environments (excludes aerospace, borders, ghostty, kanata, karabiner, sketchybar)
./setup.sh --mode headless
# or: MODE=headless ./setup.sh

# Manual installation with stow
stow --dotfiles -t ~ .

# Dry-run to preview what stow will do
stow --dotfiles -t ~ --simulate .

# Link a single configuration module
stow --dotfiles -t ~ dot-config/nvim
```

The setup script automatically:
- Installs dotfiles using stow
- Downloads antigen (zsh plugin manager) to `~/.config/antigen/antigen.zsh`
- Clones tpm (tmux plugin manager) to `~/.tmux/plugins/tpm`

## Architecture and Structure

### Stow-Based Linking System

This repository uses GNU Stow's `--dotfiles` feature to manage symlinks. Files/directories prefixed with `dot-` get renamed with a `.` prefix when linked to `$HOME`.

**Key mechanisms:**
- `.stow-local-ignore`: Defines files that stow should skip (git metadata, README, scripts, cache files like `*.zwc`)
- `.stowrc`: Stow configuration (if needed)
- `setup.sh`: Handles mode-based filtering - in `headless` mode, it passes `--ignore` patterns to stow to skip macOS-only configs

### Directory Layout

```
.
├── dot-config/          # Maps to ~/.config/
│   ├── aerospace/       # macOS window manager (desktop only)
│   ├── borders/         # macOS window borders (desktop only)
│   ├── ghostty/         # Terminal emulator (desktop only)
│   ├── kanata/          # Keyboard remapper (desktop only)
│   ├── karabiner/       # macOS keyboard customizer (desktop only)
│   ├── nvim/            # Neovim configuration
│   ├── sketchybar/      # macOS menu bar (desktop only)
│   ├── starship/        # Prompt configuration
│   ├── tmux/            # Tmux configuration
│   └── ...
├── zsh/                 # Shell configuration modules
│   ├── alias.zsh        # Shell aliases
│   ├── antigen.zsh      # Antigen plugin manager setup
│   ├── tmux.zsh         # Tmux integration
│   ├── zshenv           # Environment variables
│   └── zshrc            # Main zsh configuration
├── dot-zshrc            # Maps to ~/.zshrc (sources zsh/zshrc)
├── zshenv               # Maps to ~/.zshenv
└── setup.sh             # Installation orchestrator
```

### Shell Configuration Loading Order

1. `~/.zshenv` (symlink from `zshenv`)
2. `~/.zshrc` (symlink from `dot-zshrc`) → sources `~/.config/zsh/zshrc`
3. `~/.config/zsh/zshrc` loads:
   - `~/.config/zsh/alias.zsh` - shell aliases
   - `~/.config/zsh/antigen.zsh` - loads antigen and plugins
   - `~/.config/zsh/tmux.zsh` - tmux integration functions
   - Starship prompt initialization
   - Zoxide initialization

### Antigen Plugin Management

Antigen cache and artifacts are stored in `${XDG_CACHE_HOME:-$HOME/.cache}/antigen`, not in the repo root. This prevents cache pollution in version control.

Active plugins (from `dot-zshrc`):
- `zsh-users/zsh-syntax-highlighting`
- `zsh-users/zsh-autosuggestions`
- `MichaelAquilina/zsh-you-should-use`
- `Aloxaf/fzf-tab`

### Tmux Configuration

`dot-config/tmux/tmux.conf` sources `tmux.reset.conf` first, then configures:
- Custom prefix: `Ctrl-Space`
- TPM plugins including catppuccin theme, sessionx, floax, vim-tmux-navigator
- Sessions configured to use zoxide and custom paths

## Validation and Testing

```bash
# Validate zsh syntax before sourcing
zsh -n zsh/zshrc

# Test with debug output
zsh -x

# Test tmux config
tmux -f ~/.config/tmux/tmux.conf

# Test Neovim health
nvim --clean +checkhealth +qall

# Check Ghostty config (if installed)
ghostty --print-config
```

## Commit Conventions

Follow Conventional Commits format: `type(scope): summary`

Common scopes: `nvim`, `zsh`, `tmux`, `ghostty`, `setup`

## Important Notes

- **Desktop vs Headless**: When modifying `setup.sh`, maintain the ignore patterns for headless mode (aerospace, borders, ghostty, kanata, karabiner, sketchybar)
- **Cache Files**: Files matching `*.zwc` are zsh compiled files and should remain gitignored
- **Secrets**: Never commit machine-specific secrets; use `~/.localrc` or similar untracked files
- **Ghostty Terminal Fix**: The zsh configuration includes special terminal line discipline fixes for Ghostty duplicate keystroke issues
- **Emacs Mode**: Zsh is configured to use emacs keybindings (not vi mode) with `bindkey -e`
