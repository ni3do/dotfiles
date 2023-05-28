# dotfiles

My macOS configuration files.
color scheme consistency across all configurations.

- neovim
- skhd
- yabai
- sketchybar

## Installation

### Install xCode cli tools

```
bash xcode-select --install
```

### Install [Homebrew](https://brew.sh/):

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Add homebrew to path:

```
echo '# Set PATH, MANPATH, etc., for Homebrew.' >> $HOME/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Run the install script:

```
bash .install.sh
```

### Add yabai to sudoers:

```
echo "$(whoami) ALL = (root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | awk "{print \$1;}") $(which yabai) --load-sa' to '/private/etc/sudoers.d/yabai"
sudo visudo -f /private/etc/sudoers.d/yabai
```

## SketchyBar Setup

- (optional) skhd shortcuts should trigger the sketchybar events, e.g.:

```bash
lalt - space : yabai -m window --toggle float; sketchybar --trigger window_focus
shift + lalt - f : yabai -m window --toggle zoom-fullscreen; sketchybar --trigger window_focus
lalt - f : yabai -m window --toggle zoom-parent; sketchybar --trigger window_focus
shift + lalt - 1 : yabai -m window --space 1 && sketchybar --trigger windows_on_spaces
```

NOTE: The `helper` C program is included here only to show off this specific
functionality of sketchybar and is not needed generally. It provides the data
for the cpu graph and the date-time. Using a `mach_helper` provides a _much_
lower overhead solution for performance sensitive tasks, since the `helper`
talks directly to sketchybar via kernel level messages.
For most tasks (including those listed above) this difference in performance
does not matter at all.

## neovim setup

- Paste my .confg/nvim/ folder
- Run PackerSync

```bash
nvim +PackerSync
```

- My remappings are in .config/nvim/lua/mappings.lua, you can change or remove them freely.

```

```
