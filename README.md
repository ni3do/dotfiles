# dotfiles

My personal dotfiles configuration.

## Installation

### Quick Install
Run the setup script (defaults to the full desktop profile):
```bash
./setup.sh
```

For servers or other headless Linux machines, skip the macOS-only tools with:
```bash
./setup.sh --mode headless
```
You can also set `MODE=headless` in the environment if you prefer (e.g. `MODE=headless ./setup.sh`).

### Manual Install
Or install manually with stow:
```bash
stow --dotfiles -t ~ .
```

The setup script will:
- Install dotfiles using stow
- Download antigen (zsh plugin manager) if not present
- Clone tpm (tmux plugin manager) if not present
- In `headless` mode it skips macOS-only configs (aerospace, borders, ghostty, kanata, karabiner, sketchybar)
