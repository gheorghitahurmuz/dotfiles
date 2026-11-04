#!/bin/bash
set -uo pipefail

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

inspect_timezone() {
    echo '--- Timezone link ---'
    ls -l /etc/localtime
    readlink /etc/localtime
    echo '--- Timezone reported by macOS (requires cached sudo) ---'
    sudo -n systemsetup -gettimezone
}

inspect_startup_sound() {
    local key value status
    echo '--- Startup sound bytes (requires cached sudo) ---'
    for key in SystemAudioVolume StartupMute; do
        echo "$key:"
        value="$(sudo -n nvram "$key" 2>&1)"
        status=$?
        printf 'exit=%s, value=<%s>\n' "$status" "$value"
        printf '%s' "$value" | od -An -tx1
    done
}

inspect_wallpaper() {
    echo '--- Desktop picture values ---'
    osascript <<'APPLESCRIPT'
with timeout of 15 seconds
    tell application "System Events"
        set results to {}
        repeat with desktop_item in every desktop
            set end of results to (picture of desktop_item) as text
        end repeat
        return results
    end tell
end timeout
APPLESCRIPT
}

main() {
    inspect_timezone
    inspect_startup_sound
    inspect_wallpaper
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
