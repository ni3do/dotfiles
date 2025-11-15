# dotfiles

My personal dotfiles configuration.

## Installation

### Quick Install
Run the setup script:
```bash
./setup.sh
```

### Manual Install
Or install manually with stow:
```bash
stow --dotfiles -t ~ .
```

The setup script will:
- Install dotfiles using stow
- Download antigen (zsh plugin manager) if not present
- Clone tpm (tmux plugin manager) if not present
