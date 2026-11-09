# Herdr

Configuration: `~/.config/herdr/config.toml` for the terminal multiplexer and
`~/.config/herdr-app/` for the desktop app.

- The Brewfile installs the `herdr` CLI. Install the desktop app separately from
  <https://herdr.dev>; it is not a Homebrew cask.
- Only `settings.json` and `themes/night-owl.json` are linked from `herdr-app`.
  The rest of that directory is runtime state the app owns.
- Herdr app saves the zoom keys into `settings.json`. If it ever replaces the
  link with a plain file, Doctor reports the conflict; merge and restow.
- The terminal multiplexer has no Night Owl theme. `config.toml` keeps a built-in
  base and recolors it through `[theme.custom]`; an unknown `name` silently falls
  back to catppuccin.
- After editing `config.toml`, run `herdr server reload-config`; the desktop
  app reloads its settings and themes by itself.
