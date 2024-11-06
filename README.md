# dotfiles
My macOS configuration files.
<img width="1512" alt="Screenshot 2024-03-14 at 14 09 39" src="https://github.com/FelixKratz/dotfiles/assets/22680421/b3376436-5d0e-41a4-9eb2-3301c8fd757a">




* [SketchyBar](https://github.com/FelixKratz/SketchyBar)
* [JankyBorders](https://github.com/FelixKratz/JankyBorders)
* [SketchyVim](https://github.com/FelixKratz/SketchyVim)
* [yabai](https://github.com/koekeishiya/yabai)
* [skhd](https://github.com/koekeishiya/skhd)
* [nnn](https://github.com/jarun/nnn)

Most setup steps are in `.install.sh`

## Setup
- Install xCode cli tools
```bash
xcode-select --install
```
- Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
- Close and reopen terminal
- Run `install.sh`
```bash
./install.sh
```

## SketchyBar Setup
The present config for sketchybar is done entirely in lua (and some C), using
[SbarLua](https://github.com/FelixKratz/SbarLua).
One-line install for sketchybar config (requires brew to be installed):
```bash
curl -L https://raw.githubusercontent.com/FelixKratz/dotfiles/master/install_sketchybar.sh | sh
```
