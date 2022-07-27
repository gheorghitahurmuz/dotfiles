#!/usr/bin/env bash

if [ $(uname) = "Darwin" ];
then
  SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
  echo "$SCRIPT_PATH"
  FLAG_FILE="${SCRIPT_PATH}/dock_configured"
  APPLICATIONS=(
    "/Applications/Obsidian.app"
    "/System/Applications/Mail.app"
    "/Applications/Alacritty.app"
    "/Applications/Visual Studio Code.app"
    "/Applications/Brave Browser.app"
  )

  if [ ! -f "${FLAG_FILE}" ]; then
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock show-recents -bool false
    defaults write com.apple.dock persistent-apps -array

    for APPLICATION in "${APPLICATIONS[@]}"; do
      defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>${APPLICATION}</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    done

    killall Dock
    touch "${FLAG_FILE}"
  fi
fi
