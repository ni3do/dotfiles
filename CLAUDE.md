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
- Installs dotfiles using stow
- Downloads antigen (zsh plugin manager) to `~/.config/antigen/antigen.zsh`
- Clones tpm (tmux plugin manager) to `~/.tmux/plugins/tpm`

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

## Validation and Testing

```bash
# Validate zsh syntax
zsh -n dot-zshrc

# Test tmux config
tmux -f ~/.config/tmux/tmux.conf

# Test Neovim health
nvim --clean +checkhealth +qall
```

## Commit Conventions

Follow Conventional Commits format: `type(scope): summary`

Common scopes: `nvim`, `zsh`, `tmux`, `ghostty`, `setup`

## Important Notes

- **Cache Files**: Files matching `*.zwc` are zsh compiled files and should remain gitignored
- **Secrets**: Never commit machine-specific secrets; use `~/.localrc` or similar untracked files
- **Emacs Mode**: Zsh is configured to use emacs keybindings (not vi mode) with `bindkey -e`
