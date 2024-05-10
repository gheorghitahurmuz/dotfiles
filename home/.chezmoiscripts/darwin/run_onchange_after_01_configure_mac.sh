#!/usr/bin/env bash

set -eufo pipefail

echo "==> 📜 Configure MacOs [General]"

osascript -e 'tell application "System Preferences" to quit'

sudo -v

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Enable Dark Mode
defaults write NSGlobalDomain AppleInterfaceStyle Dark

# Set Language to English (United States)
defaults write NSGlobalDomain AppleLanguages -array en-US

# Set Locale to en_US
defaults write NSGlobalDomain AppleLocale en_US

# Adjust Initial Key Repeat Delay
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Adjust Key Repeat Rate
defaults write NSGlobalDomain KeyRepeat -int 2

# Disable Automatic Capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable Automatic Period Substitution
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable Automatic Quote Substitution
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable Automatic Spelling Correction
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable Automatic Text Completion
defaults write NSGlobalDomain NSAutomaticTextCompletionEnabled -bool false

# Request Linguistic Data Assets
defaults write NSGlobalDomain NSLinguisticDataAssetsRequested -array en en_US

# Clear User Dictionary Replacement Items
defaults write NSGlobalDomain NSUserDictionaryReplacementItems -array

# Disable Web Automatic Spelling Correction
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

# Disable "Always Reopen Windows" in System Preferences
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Prevent .DS_Store File Creation
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# Disable Creation of Metadata Files on USB Volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show Battery Percentage in Control Center
defaults write com.apple.controlcenter BatteryShowPercentage -bool true

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Show All File Extensions
defaults write -g AppleShowAllExtensions -bool true

# Show Path Bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show Status Bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Set Finder's Default View to Column View
defaults write com.apple.finder "FXPreferredViewStyle" -string "clmv"

# Set Default Finder Location to Home Folder
defaults write com.apple.finder NewWindowTarget -string "PfLo" &&
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

# Keep Folders on Top in Finder
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"

# Set Scrollbar Visibility to Always
defaults write -g AppleShowScrollBars -string "Always"

# Disable Automatic Spelling Correction
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# Enable Continuous Spell Checking
defaults write -g NSAllowContinuousSpellChecking -bool true

# Save Screenshots to Desktop
defaults write com.apple.screencapture location ~/Desktop &&
    killall SystemUIServer

# Customize Date and Time Format in Menu Bar
defaults write com.apple.menuextra.clock "DateFormat" -string "\"EEE d MMM HH:mm:ss\""

# Autohide the Dock
defaults write com.apple.dock autohide -bool true

# Disable Recent Apps in the Dock
defaults write com.apple.dock show-recents -bool false

# Disable Auto Rearrange Spaces Based on Most Recent Use
defaults write com.apple.dock mru-spaces -bool false

# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false

# Show Hidden App Icons in the Dock
defaults write com.apple.dock showhidden -bool true

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Trackpad: Enable dragging with three finger drag
defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true"

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Allow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true
