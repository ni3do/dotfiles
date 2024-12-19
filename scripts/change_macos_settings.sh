#!/bin/zsh

# macOS Settings
echo "Changing macOS defaults..."

# Disable startup sound
sudo nvram StartupMute=%01

# Dock Settings
defaults write com.apple.dock "tilesize" -int "44"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock "mru-spaces" -bool "false"

# Change trackpad speed
defaults write -g com.apple.trackpad.scaling -float 3

# Enable tap to click.
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable the "Are you sure you want to open this application?" dialog.
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Finder Settings
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder ShowStatusBar -bool false
defaults write com.apple.finder WarnOnEmptyTrash -bool false
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Set search scope.
# This Mac       : `SCev`
# Current Folder : `SCcf`
# Previous Scope : `SCsp`
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Set preferred view style.
# Icon View   : `icnv`
# List View   : `Nlsv`
# Column View : `clmv`
# Cover Flow  : `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
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

# Screen Capture Settings
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type -string "png"

# Safari Settings
sudo defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
sudo defaults write com.apple.Safari IncludeDevelopMenu -bool true
sudo defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
sudo defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# General Settings
defaults write NSGlobalDomain _HIHideMenuBar -bool true
defaults write NSGlobalDomain AppleHighlightColor -string "0.533 0.224 0.937"
defaults write NSGlobalDomain AppleAccentColor -int 5
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Misc Settings
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.spaces spans-displays -bool false
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool YES
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
defaults write -g NSWindowShouldDragOnGesture YES

## Fix for MX Master 3S
sudo defaults write /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt Hybrid

# Disable press and hold for VSCode and Cursor
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write com.todesktop.230313mzl4w4u92 ApplePressAndHoldEnabled -bool false

# Other Key repeat settings
defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)