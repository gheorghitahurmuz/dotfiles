#!/usr/bin/env bash

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

function defaults_ui() {
    defaults write -globalDomain AppleInterfaceStyle -string Dark
    defaults write -globalDomain AppleAccentColor -int 4
    defaults write -globalDomain AppleHighlightColor -string "0.698039 0.843137 1.000000 Blue"
    defaults write -globalDomain AppleAquaColorVariant -int 1
    defaults write -globalDomain NSTableViewDefaultSizeMode -string 2
    defaults write -globalDomain AppleReduceDesktopTinting -bool FALSE
    defaults write -globalDomain AppleShowScrollBars -string Always
    defaults write -globalDomain AppleScrollerPagingBehavior -bool TRUE

    defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist BatteryShowPercentage -bool true
    defaults write com.apple.controlcenter BatteryShowPercentage -bool true

    osascript -e 'tell application "System Events" to tell every desktop to set picture to "/System/Library/Desktop Pictures/Solid Colors/Black.png" as POSIX file'
}

function defaults_language() {
    defaults write ".GlobalPreferences_m" AppleLanguages -array en-US ro-RO
    defaults write -globalDomain AppleLanguages -array en-US ro-RO

    if sudo -n true 2>/dev/null; then
        sudo systemsetup -settimezone "Europe/Bucharest" >/dev/null
    else
        echo "    Skipping timezone (requires sudo). Run manually:"
        echo "    sudo systemsetup -settimezone 'Europe/Bucharest'"
    fi

    defaults write ".GlobalPreferences_m" AppleLocale -string en_US@rg=rozzzz
    defaults write -globalDomain AppleLocale -string en_US@rg=rozzzz
}

function defaults_keyboard() {
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 25

    # Change Caps to Ctrl
    # ref. https://stackoverflow.com/a/46460200
   # Remap Caps Lock to Control (Note: resets on reboot without additional setup)
    hidutil property --set \
        '{"UserKeyMapping": [{"HIDKeyboardModifierMappingSrc": 0x700000039, "HIDKeyboardModifierMappingDst": 0x7000000e0 }] }' >/dev/null

    echo "    Caps Lock → Control mapping active for this session only"
    echo "    To persist across reboots, use System Settings > Keyboard > Modifier Keys"

    # Disable Automatic Capitalization
    defaults write -g NSAutomaticCapitalizationEnabled -bool false

    # Disable Automatic Period Substitution
    defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

    # Disable Automatic Quote Substitution
    defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

    # Disable Automatic Spelling Correction
    defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

    # Disable Automatic Text Completion
    defaults write -g NSAutomaticTextCompletionEnabled -bool false
}

function defaults_trackpad() {

    defaults write -g com.apple.trackpad.scaling 2

    # Trackpad: enable tap to click for this user and for the login screen
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

    # Enable 3-fingers drag
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
}

function defaults_controlcenter() {
    defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true
}

function defaults_software_update() {
    defaults write com.apple.SoftwareUpdate AutomaticDownload -bool TRUE
    defaults write com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool TRUE
    defaults write com.apple.commerce AutoUpdate -bool TRUE
    defaults write com.apple.SoftwareUpdate ConfigDataInstall -bool TRUE
    defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -bool TRUE
}

function defaults_finder() {
    # Set Home directory as the default location for new Finder windows
    defaults write com.apple.finder NewWindowTarget -string "PfHm"
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

    # Show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    # Disable the warning when changing a file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    # Show status bar
    defaults write com.apple.finder ShowStatusBar -bool true
    # Show path bar
    defaults write com.apple.finder ShowPathbar -bool true

    defaults write com.apple.finder FXPreferredGroupBy -string "Name"
    defaults write com.apple.finder FXArrangeGroupViewBy -string "Name"

    # Avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    # Disable the warning before emptying the Trash
    defaults write com.apple.finder WarnOnEmptyTrash -bool false

    # Enabling the “Remove items from the Trash after 30 days”
    defaults write com.apple.finder FXRemoveOldTrashItems -bool true
}


function defaults_screencapture() {
    # Save screenshots to ${HOME}/Pictures/
    defaults write com.apple.screencapture location -string "${HOME}/Pictures/"

    # disable the floating screenshot thumbnail
    defaults write com.apple.screencapture show-thumbnail -bool false
}

function defaults_dock() {
    # Move Dock to the left side of the screen
    defaults write com.apple.dock "orientation" -string "bottom"

    # Automatically hide and show the Dock
    defaults write com.apple.dock autohide -bool true
    # Set the icon size of Dock items to 30 pixels
    defaults write com.apple.dock tilesize -int 56

    # Remove all the icons in the Dock
    defaults write com.apple.dock persistent-apps -array ""
    defaults write com.apple.dock recent-apps -array ""
    defaults write com.apple.dock persistent-others -array ""

    function dock_item() {
        local app_file_path="$1"
        printf '
        <dict>
            <key>tile-data</key>
                <dict>
                    <key>file-data</key>
                        <dict>
                            <key>_CFURLString</key><string>%s</string>
                            <key>_CFURLStringType</key><integer>0</integer>
                        </dict>
                </dict>
        </dict>', "${app_file_path}"
    }

    local dock_apps=()
    [[ -d "/Applications/Google Chrome.app" ]] && dock_apps+=("$(dock_item "/Applications/Google Chrome.app")")

    if [[ "${DOTFILE_PERSONAL_DEVICE:-}" == "true" ]]; then
        [[ -d "/Applications/Zed.app" ]] && dock_apps+=("$(dock_item "/Applications/Zed.app")")
    else
        [[ -d "/Applications/Visual Studio Code.app" ]] && dock_apps+=("$(dock_item "/Applications/Visual Studio Code.app")")
    fi


    if [[ ${#dock_apps[@]} -gt 0 ]]; then
        defaults write com.apple.dock persistent-apps -array "${dock_apps[@]}"
        echo "  ✓ Added ${#dock_apps[@]} app(s) to Dock"
    else
        echo "  ⚠ No configured apps found to add to Dock"
    fi
}

function misc() {
    # Disable the sound effects on boot
    sudo nvram SystemAudioVolume=" "

    # Don’t group windows by application in Mission Control
    # (i.e. use the old Exposé behavior instead)
    defaults write com.apple.dock expose-group-by-app -bool false

    # Disable rearrangement of Mission Control
    defaults write com.apple.dock mru-spaces -bool false

    # Displays have separate Spaces
    defaults write com.apple.spaces "spans-displays" -bool false

    # Hide all icons
    defaults write com.apple.finder "CreateDesktop" -bool false

    # Create Developer Directory
    mkdir -p "$HOME/Developer"
}

function kill_affected_applications() {
    local apps=(
        "Activity Monitor"
        "Calendar"
        "cfprefsd"
        "Dock"
        "Finder"
        "SystemUIServer"
    )

    for app in "${apps[@]}"; do
        killall "${app}" || echo "Process \`${app}\` was not running."
    done
}

function main() {
    defaults_ui
    defaults_language
    defaults_keyboard
    defaults_trackpad
    defaults_controlcenter
    defaults_software_update
    defaults_finder
    defaults_screencapture
    defaults_dock
    misc

    kill_affected_applications
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
