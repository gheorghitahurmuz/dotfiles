#!/usr/bin/env bash

if [ $(uname) = "Darwin" ];
then
  # Don't write .DS* file
  defaults write com.apple.desktopservices DSDontWriteNetworkStores true

  # Show battery percentage
  defaults write com.apple.controlcenter BatteryShowPercentage -bool true
fi
