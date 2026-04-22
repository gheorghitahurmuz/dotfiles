# zsh

This directory holds modular zsh fragments rendered by chezmoi.

## Files

- `profile.d/*.zsh`: login-shell setup, environment bootstrap, PATH helpers
- `rc.d/*.zsh`: interactive-shell features and plugins

## Editing guidance

- Keep `~/.zprofile` and `~/.zshrc` as thin loaders.
- Put login-only logic in `profile.d/`.
- Put interactive-shell logic in `rc.d/`.
- Prefer one concern per file.
