# tmux

This directory owns tmux configuration.

## Files

- `tmux.conf`: top-level loader
- `options.conf`: terminal features, history, indexes, pane title settings
- `keybindings.conf`: pane, window, and session keymaps
- `statusline.conf`: status bar, pane borders, and message styling
- `macos.conf`: clipboard integration and popup helpers for macOS
- `claude.conf`: Claude workflow bindings

## Editing guidance

- Put visual changes in `statusline.conf`.
- Put behavior and defaults in `options.conf`.
- Put shortcuts in `keybindings.conf`.
- Keep platform-specific commands in `macos.conf`.

## Validation

Use the repo-level validator:

```sh
./scripts/validate-dotfiles
```
