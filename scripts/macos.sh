#!/usr/bin/env bash

set -Eeuo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "This script supports macOS only." >&2
    exit 1
fi

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

restart_apps=()
incomplete=0

mark_restart() {
    local app
    # Guard empty arrays for macOS Bash 3.2 with set -u.
    for app in ${restart_apps[@]+"${restart_apps[@]}"}; do
        [[ "$app" != "$1" ]] || return 0
    done
    restart_apps+=("$1")
}

configuration_failure() {
    incomplete=1
    printf '    FAIL %s\n' "$*" >&2
}

normalize_preference() {
    case "$1" in
        -bool)
            case "$2" in
                true|TRUE|YES|1) echo 1 ;;
                false|FALSE|NO|0) echo 0 ;;
                *) printf '%s' "$2" ;;
            esac
            ;;
        -float)
            awk -v value="$2" 'BEGIN { printf "%.12g", value }'
            ;;
        -array)
            printf '%s' "$2" | tr -d '[:space:](),"'
            ;;
        *)
            printf '%s' "$2"
            ;;
    esac
}

write_preference() {
    local host=()
    local domain key kind current expected
    if [[ "$1" == -currentHost ]]; then
        host=(-currentHost)
        shift
    fi
    domain="$1"
    key="$2"
    kind="$3"
    shift 3
    current="$(defaults ${host[@]+"${host[@]}"} read "$domain" "$key" 2>/dev/null || true)"
    expected="$(normalize_preference "$kind" "$*")"
    current="$(normalize_preference "$kind" "$current")"
    if [[ "$current" == "$expected" ]] && defaults ${host[@]+"${host[@]}"} read "$domain" "$key" >/dev/null 2>&1; then
        return 0
    fi
    if ! defaults ${host[@]+"${host[@]}"} write "$domain" "$key" "$kind" "$@"; then
        configuration_failure "Could not write $domain $key."
        return 0
    fi
    if ! current="$(defaults ${host[@]+"${host[@]}"} read "$domain" "$key" 2>/dev/null)"; then
        configuration_failure "Could not read back $domain $key."
    elif [[ "$(normalize_preference "$kind" "$current")" != "$expected" ]]; then
        configuration_failure "Could not verify $domain $key."
    fi
    case "$domain" in
        com.apple.dock|com.apple.spaces) mark_restart Dock ;;
        com.apple.finder) mark_restart Finder ;;
        com.apple.screencapture|com.apple.controlcenter|*/com.apple.controlcenter.plist) mark_restart SystemUIServer ;;
    esac
}

configure_appearance() {
    write_preference -globalDomain AppleInterfaceStyle -string Dark
    write_preference -globalDomain AppleAccentColor -int 4
    write_preference -globalDomain AppleHighlightColor -string "0.698039 0.843137 1.000000 Blue"
    write_preference -globalDomain AppleAquaColorVariant -int 1
    write_preference -globalDomain NSTableViewDefaultSizeMode -string 2
    write_preference -globalDomain AppleReduceDesktopTinting -bool FALSE
    write_preference -globalDomain AppleShowScrollBars -string Always
    write_preference -globalDomain AppleScrollerPagingBehavior -bool TRUE
    write_preference com.apple.WindowManager StandardHideWidgets -bool true

    write_preference -currentHost com.apple.controlcenter BatteryShowPercentage -bool true
    write_preference com.apple.controlcenter BatteryShowPercentage -bool true
}

configure_wallpaper() {
    if [[ -f '/System/Library/Desktop Pictures/Solid Colors/Black.png' ]] && osascript <<'APPLESCRIPT'
with timeout of 15 seconds
tell application "System Events"
    if (count of desktops) is 0 then error "No desktop session available"
    repeat with desktop_item in every desktop
        if picture of desktop_item is not "/System/Library/Desktop Pictures/Solid Colors/Black.png" then
            set picture of desktop_item to "/System/Library/Desktop Pictures/Solid Colors/Black.png" as POSIX file
        end if
        if picture of desktop_item is not "/System/Library/Desktop Pictures/Solid Colors/Black.png" then error "Wallpaper was not applied"
    end repeat
end tell
end timeout
APPLESCRIPT
    then
        :
    else
        incomplete=1
        echo "    Wallpaper configuration failed. Log into the Mac desktop, allow Automation access to System Events if prompted, then rerun bash scripts/macos.sh." >&2
    fi
}

configure_language() {
    write_preference ".GlobalPreferences_m" AppleLanguages -array en-US ro-RO
    write_preference -globalDomain AppleLanguages -array en-US ro-RO

    configure_timezone

    write_preference ".GlobalPreferences_m" AppleLocale -string en_US@rg=rozzzz
    write_preference -globalDomain AppleLocale -string en_US@rg=rozzzz
}

configure_timezone() {
    local timezone_output
    if [[ "$(readlink /etc/localtime)" != */Europe/Bucharest ]]; then
        if sudo -n true 2>/dev/null; then
            # systemsetup can print Error:-99 even when the change succeeds.
            timezone_output="$(sudo -n systemsetup -settimezone Europe/Bucharest 2>&1)" || true
            if [[ "$(readlink /etc/localtime)" != */Europe/Bucharest ]]; then
                configuration_failure "Timezone was not set to Europe/Bucharest: $timezone_output"
            fi
        else
            configuration_failure "Timezone requires sudo. Run sudo -v, then rerun this script."
        fi
    fi
}

normalize_keyboard_mappings() {
    jq -Sce 'map(
        .HIDKeyboardModifierMappingSrc |= tonumber |
        .HIDKeyboardModifierMappingDst |= tonumber
    )'
}

configure_keyboard_mapping() {
    local mapping json updated verified
    if ! mapping="$(hidutil property --get UserKeyMapping)"; then
        configuration_failure "Could not read keyboard mappings."
        return 0
    fi
    case "$mapping" in
        ""|"(null)")
            json='[]'
            ;;
        *)
            if ! json="$(printf '%s' "$mapping" | plutil -convert json -o - -- -)"; then
                configuration_failure "Could not parse keyboard mappings; existing mappings preserved."
                return 0
            fi
            ;;
    esac
    if ! json="$(printf '%s' "$json" | normalize_keyboard_mappings)"; then
        configuration_failure "Invalid keyboard mapping values; existing mappings preserved."
        return 0
    fi
    if ! updated="$(printf '%s' "$json" | jq -ce '
        if type != "array" then error("Expected mapping array") else . end |
        if any(.[];
            .HIDKeyboardModifierMappingSrc == 30064771129 and
            .HIDKeyboardModifierMappingDst != 30064771296
        ) then
            error("Caps Lock already has a different mapping")
        elif any(.[]; .HIDKeyboardModifierMappingSrc == 30064771129) then
            .
        else
            . + [{
                HIDKeyboardModifierMappingSrc: 30064771129,
                HIDKeyboardModifierMappingDst: 30064771296
            }]
        end')"; then
        configuration_failure "Keyboard mappings conflict or are invalid; existing mappings preserved."
        return 0
    fi
    if [[ "$(printf '%s' "$json" | jq -c .)" != "$updated" ]]; then
        if ! hidutil property --set "{\"UserKeyMapping\":$updated}" >/dev/null; then
            configuration_failure "Could not apply keyboard mappings."
            return 0
        fi
    fi
    if ! verified="$(hidutil property --get UserKeyMapping)"; then
        configuration_failure "Could not verify keyboard mappings."
        return 0
    fi
    if ! verified="$(printf '%s' "$verified" | plutil -convert json -o - -- - | normalize_keyboard_mappings)"; then
        configuration_failure "Could not verify keyboard mappings."
        return 0
    fi
    if [[ "$verified" != "$(printf '%s' "$updated" | normalize_keyboard_mappings)" ]]; then
        configuration_failure "Could not verify keyboard mappings."
        return 0
    fi
    echo "    Caps Lock → Control verified for this session; other mappings preserved."
}

configure_keyboard() {
    write_preference NSGlobalDomain KeyRepeat -int 2
    write_preference NSGlobalDomain InitialKeyRepeat -int 25

    # Session-only mapping: https://stackoverflow.com/a/46460200
    configure_keyboard_mapping

    # Disable Automatic Capitalization
    write_preference -g NSAutomaticCapitalizationEnabled -bool false

    # Disable Automatic Period Substitution
    write_preference -g NSAutomaticPeriodSubstitutionEnabled -bool false

    # Disable Automatic Quote Substitution
    write_preference -g NSAutomaticQuoteSubstitutionEnabled -bool false

    # Disable Automatic Spelling Correction
    write_preference -g NSAutomaticSpellingCorrectionEnabled -bool false

    # Disable Automatic Text Completion
    write_preference -g NSAutomaticTextCompletionEnabled -bool false
}

configure_trackpad() {
    write_preference -g com.apple.trackpad.scaling -float 2

    # Trackpad: enable tap to click for this user and for the login screen
    write_preference NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    write_preference -currentHost NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    write_preference com.apple.AppleMultitouchTrackpad Clicking -bool true
    write_preference com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

    # Enable 3-fingers drag
    write_preference com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
    write_preference com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
}

configure_control_center() {
    write_preference com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true
}

configure_software_updates() {
    write_preference com.apple.SoftwareUpdate AutomaticDownload -bool TRUE
    write_preference com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool TRUE
    write_preference com.apple.commerce AutoUpdate -bool TRUE
    write_preference com.apple.SoftwareUpdate ConfigDataInstall -bool TRUE
    write_preference com.apple.SoftwareUpdate CriticalUpdateInstall -bool TRUE
}

configure_finder() {
    write_preference com.apple.finder CreateDesktop -bool false

    # Set Home directory as the default location for new Finder windows
    write_preference com.apple.finder NewWindowTarget -string "PfHm"
    write_preference com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

    # Show all filename extensions
    write_preference NSGlobalDomain AppleShowAllExtensions -bool true
    # Disable the warning when changing a file extension
    write_preference com.apple.finder FXEnableExtensionChangeWarning -bool false
    # Show status bar
    write_preference com.apple.finder ShowStatusBar -bool true
    # Show path bar
    write_preference com.apple.finder ShowPathbar -bool true

    write_preference com.apple.finder FXPreferredGroupBy -string "Name"
    write_preference com.apple.finder FXArrangeGroupViewBy -string "Name"

    # Avoid creating .DS_Store files on network or USB volumes
    write_preference com.apple.desktopservices DSDontWriteNetworkStores -bool true
    write_preference com.apple.desktopservices DSDontWriteUSBStores -bool true

    # Disable the warning before emptying the Trash
    write_preference com.apple.finder WarnOnEmptyTrash -bool false

    # Enabling the “Remove items from the Trash after 30 days”
    write_preference com.apple.finder FXRemoveOldTrashItems -bool true
}

configure_screenshots() {
    # Save screenshots to ${HOME}/Pictures/
    write_preference com.apple.screencapture location -string "${HOME}/Pictures/"

    # disable the floating screenshot thumbnail
    write_preference com.apple.screencapture show-thumbnail -bool false
}

dock_item() {
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
    </dict>' "${app_file_path}"
}

dock_paths_match() {
    local expected_paths=("$@")
    local snapshot current index count same=1
    snapshot="$(mktemp)"
    if defaults export com.apple.dock - > "$snapshot"; then
        count="$(plutil -extract persistent-apps raw -o - "$snapshot" 2>/dev/null || echo missing)"
        [[ "$count" == "${#expected_paths[@]}" ]] || same=0
        for ((index=0; index<${#expected_paths[@]}; index++)); do
            current="$(/usr/libexec/PlistBuddy -c "Print :persistent-apps:$index:tile-data:file-data:_CFURLString" "$snapshot" 2>/dev/null || true)"
            current="${current#file://}"
            current="${current//%20/ }"
            current="${current%/}"
            [[ "$current" == "${expected_paths[$index]}" ]] || same=0
        done
    else
        same=0
    fi
    rm -f "$snapshot"
    [[ "$same" == 1 ]]
}

configure_dock() {
    # Move Dock to the bottom of the screen
    write_preference com.apple.dock "orientation" -string "bottom"

    # Automatically hide and show the Dock
    write_preference com.apple.dock autohide -bool true
    # Set the icon size of Dock items to 56 pixels
    write_preference com.apple.dock tilesize -int 56

    # Remove recent apps and non-application items.
    write_preference com.apple.dock recent-apps -array
    write_preference com.apple.dock persistent-others -array

    local dock_apps=()
    local dock_paths=()
    if [[ -d "/Applications/Google Chrome.app" ]]; then
        dock_paths+=("/Applications/Google Chrome.app")
        dock_apps+=("$(dock_item "/Applications/Google Chrome.app")")
    fi

    if [[ -d "/Applications/Zed.app" ]]; then
        dock_paths+=("/Applications/Zed.app")
        dock_apps+=("$(dock_item "/Applications/Zed.app")")
    fi

    if dock_paths_match ${dock_paths[@]+"${dock_paths[@]}"}; then
        return 0
    fi

    if ! defaults write com.apple.dock persistent-apps -array ${dock_apps[@]+"${dock_apps[@]}"}; then
        configuration_failure "Could not write Dock applications."
        return 0
    fi

    mark_restart Dock
    if ! dock_paths_match ${dock_paths[@]+"${dock_paths[@]}"}; then
        configuration_failure "Could not verify ordered Dock application paths."
    fi
}

configure_startup_sound() {
    # Compare NVRAM state before and after the write.
    if [[ "$(nvram SystemAudioVolume 2>/dev/null || true)" != $'SystemAudioVolume\t%20' ]]; then
        if sudo -n true 2>/dev/null; then
            if ! sudo -n nvram SystemAudioVolume=" "; then
                configuration_failure "Could not set startup sound volume."
            elif [[ "$(nvram SystemAudioVolume 2>/dev/null || true)" != $'SystemAudioVolume\t%20' ]]; then
                configuration_failure "Could not verify startup sound volume."
            fi
        else
            configuration_failure "Startup sound requires sudo. Run sudo -v, then rerun this script."
        fi
    fi
}

configure_mission_control() {
    # Don’t group windows by application in Mission Control
    # (i.e. use the old Exposé behavior instead)
    write_preference com.apple.dock expose-group-by-app -bool false

    # Disable rearrangement of Mission Control
    write_preference com.apple.dock mru-spaces -bool false

    # Displays have separate Spaces
    write_preference com.apple.spaces "spans-displays" -bool false
}

restart_affected_applications() {
    local app
    for app in ${restart_apps[@]+"${restart_apps[@]}"}; do
        killall "$app" 2>/dev/null || true
    done
}

handle_unexpected_error() {
    local status="$1"
    trap - ERR
    restart_affected_applications
    echo "macOS configuration stopped unexpectedly (exit $status); previous changes may be partial." >&2
    exit "$status"
}

main() {
    trap 'handle_unexpected_error "$?"' ERR
    if [[ -t 0 ]] && ! sudo -n true 2>/dev/null; then
        sudo -v || configuration_failure "Administrative authorization unavailable."
    fi
    configure_appearance
    configure_wallpaper
    configure_language
    configure_keyboard
    configure_trackpad
    configure_control_center
    configure_software_updates
    configure_finder
    configure_screenshots
    configure_dock
    configure_startup_sound
    configure_mission_control
    mkdir -p "$HOME/Developer"

    restart_affected_applications
    if [[ "$incomplete" == 1 ]]; then
        echo "macOS configuration incomplete. Resolve the reported failures or skipped settings, run sudo -v if needed, then rerun bash scripts/macos.sh."
        return 1
    fi
    echo "macOS preference values are verified. Some effects require logout and login."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
