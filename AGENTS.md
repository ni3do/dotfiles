# AGENTS.md

Guidance for coding agents (Claude Code, pi, Codex, Cursor, …) working in this
repository. `CLAUDE.md` is a symlink to this file, so there is one source of
truth — edit this file, never the symlink target separately.

## Repository Overview

Personal dotfiles managed with GNU Stow: zsh, Ghostty, tmux, Neovim, the pi
coding agent, and the macOS desktop stack (AeroSpace, Kanata, SketchyBar,
borders).

**These files are live.** Everything here is symlinked into `$HOME`, so editing
a file in this repo edits the running configuration immediately, and the git
working tree *is* the machine state. There is no separate "apply" step.

## Installation and Setup Commands

```bash
# Full desktop profile (macOS)
./setup.sh

# Headless profile: skips macOS-only casks and unlinks their configs
./setup.sh --mode headless      # or MODE=headless ./setup.sh

# Manual installation with stow
stow --dotfiles -t ~ .

# Dry-run to preview what stow will do
stow --dotfiles -t ~ --simulate .

# Remove all symlinks
stow --dotfiles -t ~ -D .
```

`setup.sh` installs Homebrew packages (core CLI tools always; sketchybar,
borders, kanata, ghostty and aerospace only in desktop mode), installs fonts on
desktop, links everything with stow, downloads antigen to
`~/.config/antigen/antigen.zsh`, and clones tpm to `~/.tmux/plugins/tpm`.
Non-macOS hosts are switched to headless automatically.

## Setting Up a New Machine

Runbook for an agent provisioning this config from scratch.

**1. Prerequisites.** Install Homebrew (<https://brew.sh>) and the Xcode command
line tools (`xcode-select --install`). The repository is public, so no
authentication is needed to clone; pushing needs an SSH key.

**2. Clone to exactly `~/repo/dotfiles`.**

```bash
git clone https://github.com/ni3do/dotfiles.git ~/repo/dotfiles
```

The path is not arbitrary. Stow writes links *relative* to `$HOME`
(`~/.zshrc -> repo/dotfiles/dot-zshrc`), so cloning anywhere else produces links
that resolve differently or break. If the repo must live elsewhere, re-run stow
from that location rather than moving a stowed tree.

**3. Run the installer.**

```bash
cd ~/repo/dotfiles
./setup.sh                    # macOS desktop
./setup.sh --mode headless    # server / Linux
```

It is idempotent — safe to re-run. If it prints a `kept …pre-stow` warning, a
pre-existing file collides with a repo-managed name; inspect and merge those
files by hand, then delete the `.pre-stow` directory. Never delete it unread.

On a machine that already has a `~/.zshrc`, stow reports a conflict and exits 1
without linking anything — the existing file is not touched. Top-level targets
(`~/.zshrc`, `~/.luarc.json`, `~/CLAUDE.md`, `~/AGENTS.md`) are not covered by
the `.pre-stow` merge, so move them aside first and re-run.

**4. Steps the installer cannot perform.** These need a GUI, a login, or
secrets, so an agent should carry them out interactively or hand them to the
user:

- **macOS permissions.** AeroSpace and Kanata need Accessibility and Input
  Monitoring under System Settings → Privacy & Security. Kanata additionally
  requires the Karabiner VirtualHIDDevice driver.
- **tmux plugins.** Start tmux and press `Ctrl-Space` then `I` to have tpm
  install the plugins listed in `tmux.conf`.
- **Neovim.** The first `nvim` launch bootstraps LazyVim and installs plugins
  from `lazy-lock.json`; let it finish before judging health output.
- **pi.** Run `pi` once to authenticate. This writes `~/.pi/agent/auth.json`,
  which is deliberately untracked — never commit or copy it into the repo. Then
  install the packages named in `settings.json`: `pi-web-access`, `pi-ask-user`,
  `pi-notify`.
- **AWS.** `dot-zshrc` exports `AWS_PROFILE=infomaniak`; the matching
  credentials in `~/.aws` are not in this repo.
- **Optional toolchains.** nvm, pnpm and grok are sourced only if present — the
  shell starts fine without them, so install only what is needed.
- **Fonts.** Restart the terminal after setup so the Nerd Font is picked up.

**5. Verify.**

```bash
stow --dotfiles -t ~ --simulate .   # must exit 0
zsh -lic 'echo shell ok'            # login shell starts without errors
ls -l ~/.zshrc ~/.config/nvim       # symlinks into the repo, not copies
ls -l ~/.pi/agent                   # settings/themes linked; auth.json a real file
git -C ~/repo/dotfiles status       # clean
```

A non-symlink where a symlink is expected means stow was bypassed; a dirty git
status straight after install means something wrote into the repo — investigate
before committing, it is usually the tree-folding trap below.

## Stow Behaviour — Read Before Touching setup.sh

These are non-obvious and have each caused a real bug:

- **Tree folding.** If a target directory does not exist, stow links the *whole*
  directory rather than its contents: `~/.config -> repo/dot-config`. Anything
  then written to `~/.config/...` lands **inside this repository**. `setup.sh`
  pre-creates `~/.config`, `~/.local` and `~/.pi/agent` to force per-entry links.
  This is why `~/.pi/agent` must exist before stowing: otherwise pi writes
  `auth.json` and `sessions/` into version control.
- **Ignore lists only apply to top-level package entries.** Patterns such as
  `^/dot-config/aerospace$` in `.stow-local-ignore` do **not** exclude nested
  directories, and `--no-folding` does not change this. Top-level patterns
  (`^/README.*`, `^/setup\.sh$`) do work. Headless mode therefore unlinks the
  macOS-only configs after stowing rather than trying to skip them.
- **`--ignore` on the command line is ignored** when `.stow-local-ignore` exists.
- Stow only recognises symlinks it created — **relative** links into the stow
  directory. Hand-made absolute symlinks report `existing target is not owned by
  stow` and make stow exit non-zero.

`.stow-local-ignore` lists what stow skips (git metadata, README, `setup.sh`,
`*.zwc`, machine-specific configs). There is no `.stowrc`.

## Directory Layout

```
.
├── dot-config/          # Maps to ~/.config/
│   ├── aerospace/       # macOS window manager
│   ├── borders/         # macOS window borders
│   ├── claude/          # statusline.sh for Claude Code
│   ├── ghostty/         # Terminal emulator
│   ├── kanata/          # Keyboard remapper
│   ├── nvim/            # Neovim configuration (LazyVim)
│   ├── sketchybar/      # macOS menu bar
│   ├── starship/        # Prompt configuration
│   └── tmux/            # Tmux configuration
├── dot-local/bin/       # Maps to ~/.local/bin/
│   └── ts               # Interactive tmux session picker (fzf)
├── dot-pi/agent/        # Maps to ~/.pi/agent/ (pi coding agent)
│   ├── settings.json    # Provider/model, theme, packages
│   ├── extensions/      # Local TypeScript extensions (custom footer)
│   └── themes/          # Catppuccin and Tokyo Night TUI themes
├── dot-zshrc            # Maps to ~/.zshrc (single-file zsh config)
├── AGENTS.md            # This file (CLAUDE.md symlinks here)
└── setup.sh             # Installation orchestrator
```

Pi runtime state — `auth.json`, `sessions/`, `.update-check` — stays in `$HOME`
and is gitignored. Never commit it.

## Shell Configuration

All zsh config lives in `dot-zshrc`. It loads antigen with `oh-my-zsh` and the
bundles `git`, `zsh-syntax-highlighting`, `zsh-autosuggestions`,
`zsh-you-should-use` and `fzf-tab`, then starship and zoxide.

Antigen cache lives in `${XDG_CACHE_HOME:-$HOME/.cache}/antigen`.

Homebrew is resolved at runtime: `/opt/homebrew` on macOS, falling back to
linuxbrew, so the same file works on both. Keep it that way — do not hardcode
either prefix, and derive paths from `$HOME` rather than `/Users/...`.

Because `~/.zshrc` is a symlink into this repo, installers that "back up your
shell config" drop their backups **here**. `*.bak*` is gitignored for that
reason; delete such files rather than committing them.

## Tmux Configuration

`dot-config/tmux/tmux.conf`:
- Custom prefix: `Ctrl-Space`
- TPM plugins: tpm, vim-tmux-navigator, tmux-which-key, tmux-sessionx,
  tmux-floax, catppuccin

## SketchyBar Configuration

`dot-config/sketchybar/` provides a floating Catppuccin Mocha menu bar
(`height=32`, `corner_radius=10`, pill-style item backgrounds).

**Items (left to right):** spaces (AeroSpace workspaces with app icons), front
app, media (Spotify, centred), CPU, memory, volume, WiFi, battery, weather
(wttr.in), calendar.

```
sketchybar/
├── sketchybarrc      # Main config, sources all components
├── bar.sh            # Bar appearance (floating style)
├── colors.sh         # Catppuccin Mocha palette
├── defaults.sh       # Default item styling
├── items/            # One file per item listed above
└── plugins/          # Scripts that update items
```

**Required fonts:** `JetBrainsMono Nerd Font Propo` (labels),
`sketchybar-app-font` (app icons), `SF Pro` (SF Symbols).

**Reloading:**
```bash
killall sketchybar; sketchybar &
```

## AeroSpace Configuration

`dot-config/aerospace/aerospace.toml`:
- 8px inner and outer gaps; `outer.top` is per-monitor —
  `[{monitor.'LC49G95T' = 56}, 14]`, i.e. 56px on the external display to clear
  sketchybar, 14px elsewhere
- Vim navigation: `alt-h/j/k/l` focus, `alt-shift-h/j/k/l` move
- Workspaces: `alt-a/s/d/f/g` for 1–5
- Quick launch: `alt-t` terminal, `alt-b` browser, `alt-m` music
- Service mode: `alt-shift-;` then `esc` to reload

## Validation and Testing

```bash
zsh -n dot-zshrc                      # zsh syntax
bash -n setup.sh                      # installer syntax
bash -n dot-local/bin/ts              # picker syntax
stow --dotfiles -t ~ --simulate .     # must exit 0; non-zero means conflicts
tmux -f ~/.config/tmux/tmux.conf      # tmux config
nvim --clean +checkhealth +qall       # Neovim health
sketchybar --query bar                # sketchybar config
aerospace reload-config               # aerospace config
```

When changing `setup.sh`, test it against a scratch `$HOME` with `brew`, `curl`
and `git` stubbed rather than running it for real — it is destructive by design
(it moves `~/.config` aside).

## Commit Conventions

Conventional Commits: `type(scope): summary`.

Scopes in use: `nvim`, `zsh`, `tmux`, `ghostty`, `sketchybar`, `aerospace`,
`kanata`, `pi`, `ts`, `setup`, `docs`.

## Important Notes

- **Cache files:** `*.zwc` are compiled zsh files; keep them gitignored.
- **Secrets:** never commit machine-specific secrets; use `~/.localrc` or
  another untracked file. `AWS_PROFILE` is set in `dot-zshrc`; credentials are
  not.
- **Emacs mode:** zsh uses emacs keybindings (`bindkey -e`), not vi mode.
