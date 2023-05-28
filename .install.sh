#!/bin/zsh

# use fingerprint for sudo password in terminal
match='# sudo: auth account password session'
insert='auth       sufficient     pam_tid.so'
file='/etc/pam.d/sudo'

sudo sed -i '' "s/$match/$match\n$insert/" $file

# Brew Taps
echo "Installing Brew Formulae..."
brew analytics off
brew tap homebrew/cask-fonts
brew tap koekeishiya/formulae
brew tap homebrew/cask-fonts

# Brew Formulae
brew install mas
brew install neovim
brew install wget
brew install neofetch
brew install texlive
brew install starship
brew install alfred
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting
brew install skhd
brew install yabai
brew install sketchybar
brew install sf-symbols
brew install docker
brew install node
brew install docker-compose
brew install tmux
brew install yarn

# Brew Casks
echo "Installing Brew Casks..."
brew install --cask bitwarden
brew install --cask nextcloud
brew install --cask warp
brew install --cask firefox
brew install --cask visual-studio-code
brew install --cask nordvpn
brew install --cask discord
brew install --cask spotify
brew install --cask signal
brew install --cask whatsapp
brew install --cask telegram
brew install --cask zoom
brew install --cask vlc
brew install --cask font-delugia-mono-complete
brew install --cask font-delugia-complete
brew install --cask miniconda
brew install --cask docker

# Mac App Store Apps
echo "Installing Mac App Store Apps..."
mas install 462058435 # Microsoft Excel
mas install 985367838 # Microsoft Outlook
mas install 462062816 # Microsoft PowerPoint
mas install 462054704 # Microsoft Word

# macOS Settings
echo "Changing macOS defaults..."

# Dock item size
defaults write com.apple.dock "tilesize" -int "44"

# Change trackpad speed
defaults write -g com.apple.trackpad.scaling -float 3

# Hot Corners setup
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-br-corner -int 12
defaults write com.apple.dock wvous-tr-corner -int 2
defaults write com.apple.dock wvous-tl-corner -int 11

# Disable startup sound
sudo nvram StartupMute=%01

# Enable tap to click.
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock "mru-spaces" -bool "false"
# Disable the "Are you sure you want to open this application?" dialog.
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Finder
defaults write com.apple.finder AppleShowAllFiles -bool true                 # Show hidden files.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true              # Show all file extensions.
defaults write com.apple.finder FXEnableExtensionsChangeWarning -bool false  # Disable file extension change warning.
defaults write com.apple.finder ShowStatusBar -bool true                     # Show status bar.
defaults write com.apple.finder ShowPathbar -bool true                       # Show path bar.
defaults write com.apple.finder ShowRecentTags -bool false                   # Hide tags in sidebar.
defaults write com.apple.finder WarnOnEmptyTrash -bool false                 # No warning before emptying trash.

# Set search scope.
# This Mac       : `SCev`
# Current Folder : `SCcf`
# Previous Scope : `SCsp`
defaults write com.apple.finder FXDefaultSearchScope SCcf

# Set preferred view style.
# Icon View   : `icnv`
# List View   : `Nlsv`
# Column View : `clmv`
# Cover Flow  : `Flwv`
defaults write com.apple.finder FXPreferredViewStyle clmv
rm -rf ~/.DS_Store

# Set default path for new windows.
# Computer     : `PfCm`
# Volume       : `PfVo`
# $HOME        : `PfHm`
# Desktop      : `PfDe`
# Documents    : `PfDo`
# All My Files : `PfAF`
# Other…       : `PfLo`
defaults write com.apple.finder NewWindowTarget PfHm
killall Finder

# Automatically quit printer app once the print jobs complete.
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Prevent Photos from opening automatically when devices are plugged in.
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

defaults write NSGlobalDomain _HIHideMenuBar -bool true
defaults write NSGlobalDomain AppleHighlightColor -string "0.65098 0.85490 0.58431"
defaults write NSGlobalDomain AppleAccentColor -int 5

defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type -string "png"
# don't show ext. HDD or servers on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
#show full path in finder title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Copying and checking out configuration files
echo "Planting Configuration Files..."
[ ! -d "$HOME/.dotfiles" ] && git clone --bare https://github.com/ni3do/dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout master

curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v1.0.3/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

source $HOME/.zshrc
cfg config --local status.showUntrackedFiles no

# Python Packages
echo "Installing Python Packages..."
source $HOME/.zshrc
conda install pandas
conda install numpy
conda install matplotlib

# Start Services
echo "Starting Services (grant permissions)..."
brew services start skhd
brew services start yabai
brew services start sketchybar

csrutil status
echo "Do not forget to disable SIP"
echo "Add sudoer manually:"
echo "$(whoami) ALL = (root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | awk "{print \$1;}") $(which yabai) --load-sa' to '/private/etc/sudoers.d/yabai"
echo "Installation complete..."
echo "Run: 'nvim +PackerSync' and Restart..."
