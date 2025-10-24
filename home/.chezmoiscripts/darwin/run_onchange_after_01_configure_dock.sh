#!/usr/bin/env bash

set -eufo pipefail

echo "==> 📜 Configure Dock"

trap 'killall Dock' EXIT

# Remove all Apps from the Dock
defaults write com.apple.dock persistent-apps -array

apps=(
  "/Applications/Google Chrome.app"
  "/Applications/Visual Studio Code.app"
  "/Applications/Warp.app"
)

for app in "${apps[@]}"; do
  if [ -e "$app" ]; then
    defaults write com.apple.dock persistent-apps -array-add "
    <dict>
        <key>tile-data</key>
        <dict>
            <key>file-data</key>
            <dict>
                <key>_CFURLString</key>
                <string>$app</string>
                <key>_CFURLStringType</key>
                <integer>0</integer>
            </dict>
        </dict>
    </dict>"
  fi
done
