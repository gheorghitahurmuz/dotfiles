#!/usr/bin/env bash

set -eufo pipefail

if defaults read -app Raycast >/dev/null 2>&1; then
  echo "==> 📜 Configure Raycast"

  current_user=$(whoami)

  defaults write -app Raycast "NSStatusItem Visible raycastIcon" -bool false
  defaults write -app Raycast onboardingCompleted -bool true
  defaults write -app Raycast onboarding_setupHotkey -bool true
  defaults write -app Raycast onboarding_showTasksProgress -bool true
  defaults write -app Raycast permissions.folders.read:/Users/${current_user}/Documents -bool true
  defaults write -app Raycast permissions.folders.read:/Users/${current_user}/Desktop -bool true
  defaults write -app Raycast permissions.folders.read:/Users/${current_user}/Downloads -bool true
  defaults write -app Raycast permissions.folders.read:cloudStorage -bool true
  defaults write -app Raycast raycastGlobalHotkey -string Command-49
  defaults write -app Raycast showGettingStartedLink -boolean false
  defaults write -app Raycast permissions.folders.read:removableVolumes -bool true
  defaults write -app Raycast raycastPreferredWindowMode -string compact
  defaults write -app Raycast store_migratedNative -bool true
  defaults write -app Raycast store_migratedReminders -bool true
  defaults write -app Raycast store_migratedHackerNews -bool true
  defaults write -app Raycast raycastShouldFollowSystemAppearance -bool true
fi
