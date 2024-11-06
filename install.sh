#!/bin/zsh

# Enable Touch ID for sudo
./scripts/enable_touchid_sudo.sh

# Install Brew Formulae and Casks
./scripts/install_brew_packages.sh

# Install Mac App Store Apps
./scripts/install_mas_apps.sh

# Change macOS settings
./scripts/change_macos_settings.sh

# Install Fonts
./scripts/install_fonts.sh

# Install SketchyBar
./scripts/install_sketchybar.sh

# Plant dotfiles
./scripts/plant_dotfiles.sh

source $HOME/.zshrc

# Start Services
echo "Starting Services (grant permissions)..."
skhd --restart-service
brew services restart fyabai
brew services restart sketchybar
brew services restart borders
brew services restart svim

csrutil status
echo "(optional) Disable SIP for advanced yabai features."
echo "(optional) Add sudoer manually:\n '$(whoami) ALL = (root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | awk "{print \$1;}") $(which yabai) --load-sa' to '/private/etc/sudoers.d/yabai'"
echo "Installation complete...\n"
