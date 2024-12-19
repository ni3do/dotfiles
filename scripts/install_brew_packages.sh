#!/bin/zsh

## Taps
echo "Tapping Brew..."
brew tap FelixKratz/formulae
brew tap koekeishiya/formulae

## Formulae
echo "Installing Brew Formulae..."
### Essentials
brew install wget
brew install tmux
brew install mas
brew install gh
brew install ifstat
brew install skhd
brew install sketchybar
brew install borders
brew install koekeishiya/formulae/yabai

### Terminal
brew install neovim
brew install starship
brew install zsh-autosuggestions
brew install zsh-fast-syntax-highlighting

### Nice to have
brew install btop
brew install lazygit
brew install pre-commit
brew install mypy

## Casks
echo "Installing Brew Casks..."
### Terminals, Editors & Browsers
brew install --cask cursor
brew install --cask visual-studio-code
brew install --cask warp
brew install --cask kitty
brew install --cask firefox

### Office
brew install --cask nordvpn
brew install --cask discord
brew install --cask spotify
brew install --cask whatsapp
brew install --cask telegram
brew install --cask signal
brew install --cask miniconda
brew install --cask docker
brew install --cask unnaturalscrollwheels

### Nice to have
brew install --cask alfred
brew install --cask macs-fan-control

### Fonts
brew install --cask sf-symbols
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono
brew install --cask font-fira-code
brew install --cask font-delugia-mono-complete
brew install --cask font-delugia-complete
