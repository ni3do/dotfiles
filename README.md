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

## Pi Coding Agent

Pi configuration is managed under `dot-pi/agent/`, which stows to `~/.pi/agent/`:

- `settings.json` — default provider/model, scoped model list, active theme, and installed packages
- `extensions/` — local TypeScript extensions such as the custom footer and curl-based fallback web tools
- `themes/` — Catppuccin and Tokyo Night TUI themes
- `prompts/` — reusable slash prompt templates for wiki, review, and commit workflows

Secrets and runtime data are intentionally not tracked: `auth.json`, session logs, package install caches, and update-check files stay local.
