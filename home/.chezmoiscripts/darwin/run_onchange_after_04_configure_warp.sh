#!/usr/bin/env bash

set -eufo pipefail

echo "==> 📜 Configure Warp Terminal"

current_user=$(whoami)

workingDirectoryConfig="{\"advanced_mode\":false,\"global\":{\"mode\":\"CustomDir\",\"custom_dir\":\"/Users/${current_user}/Developer\"},\"split_pane\":{\"mode\":\"PreviousDir\",\"custom_dir\":\"\"},\"new_tab\":{\"mode\":\"PreviousDir\",\"custom_dir\":\"\"},\"new_window\":{\"mode\":\"PreviousDir\",\"custom_dir\":\"\"}}"
selectedSystemThemes="{\"light\":\"Light\",\"dark\":{\"Custom\":{\"name\":\"Night Owl\",\"path\":\"/Users/${current_user}/.warp/themes/night_owl.yml\"}}}"
theme="{\"Custom\":{\"name\":\"Night Owl\",\"path\":\"/Users/${current_user}/.warp/themes/night_owl.yml\"}}";

defaults write -app Warp AliasExpansionEnabled -string 'false'
defaults write -app Warp HonorPS1 -string 'true'
defaults write -app Warp LineHeightRatio -string '1.5'
defaults write -app Warp SelectedSystemThemes -string "${selectedSystemThemes}"
defaults write -app Warp QuakeModeEnabled -string 'true'
defaults write -app Warp HasAutoOpenedWelcomeFolder -bool true
defaults write -app Warp RestoreSession -string 'false'
defaults write -app Warp CompletionsOpenWhileTyping -string 'false'
defaults write -app Warp VimModeEnabled -string 'true'
defaults write -app Warp AliasExpansionBannerSeen -string 'true'
defaults write -app Warp QuakeModeSettings -string '{"keybinding":{"ctrl":true,"alt":false,"shift":false,"cmd":false,"meta":false,"key":"enter"},"active_pin_position":"Top","pin_position_to_size_percentages":{"Left":{"width":40,"height":100},"Top":{"width":100,"height":50},"Bottom":{"width":100,"height":30},"Right":{"width":40,"height":100}},"pin_screen":null,"hide_window_when_unfocused":true}'
defaults write -app Warp VimKeybindingsBannerState -string '"Dismissed"'
defaults write -app Warp CopyOnSelect -string 'true'
defaults write -app Warp MatchNotebookToMonospaceFontSize -string 'true'
defaults write -app Warp ActivationHotkeyEnabled -string 'false'
defaults write -app Warp AutocompleteSymbols -string 'false'
defaults write -app Warp WorkingDirectoryConfig -string "${workingDirectoryConfig}"
defaults write -app Warp ReceivedReferralTheme -string '"Inactive"'
defaults write -app Warp ShowWarningBeforeLogOut -string false
defaults write -app Warp SystemTheme -bool false
defaults write -app Warp NewTabPlacement -string '"AfterAllTabs"'
defaults write -app Warp UseAudibleBell -string 'false'
defaults write -app Warp Shortcuts -string 'false'
defaults write -app Warp PreferMarkdownViewer -string 'false'
defaults write -app Warp CommandCorrections -string 'false'
defaults write -app Warp NotebookFontSize -string '14.0'
defaults write -app Warp ShowIndicatorsButton -string 'true'
defaults write -app Warp ShowHintText -string 'false'
defaults write -app Warp OpenWindowsAtCustomSize -string 'false'
defaults write -app Warp ErrorUnderliningEnabled -string 'true'
defaults write -app Warp ShowWarningBeforeQuitting -string 'false'
defaults write -app Warp Spacing -string '"Normal"'
defaults write -app Warp ShowChangelogAfterUpdate -string 'false'
defaults write -app Warp SmartSelect -string 'true'
defaults write -app Warp LineDHeightRatio -string '1.5'
defaults write -app Warp Theme -string "${theme}"
defaults write -app Warp WorkflowsBoxOpen -string 'true'
defaults write -app Warp UndoCloseEnabled -string 'false'
defaults write -app Warp Notifications -string '{"mode":"Disabled","is_long_running_enabled":true,"long_running_threshold":{"secs":30,"nanos":0},"is_password_prompt_enabled":true}'
defaults write -app Warp FontName -string '"FiraCode Nerd Font Mono"'
defaults write -app Warp SyntaxHighlighting -string 'true'
defaults write -app Warp DismissedWarpAIWarmWelcome -string 'true'
defaults write -app Warp SavedPrompt -string '"Default"'
defaults write -app Warp LaunchNotebookShown -string 'true'
defaults write -app Warp WelcomeTipsCompleted -string 'true'
defaults write -app Warp ShouldDimInactivePanes -string 'true'
defaults write -app Warp FontSize -string '14.0'
defaults write -app Warp CursorBlink -string '"Enabled"'