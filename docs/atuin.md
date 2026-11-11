# Atuin

Configuration: `~/.config/atuin/config.toml`. Data, including the encryption
`key`, lives in `~/.local/share/atuin/`.

- History and captured agent threads stay on this machine. Threads share the
  record store with history and cannot be excluded from sync on their own, so
  sync is off: `auto_sync = false`, and `sync_address` points at a closed local
  port so an accidental `atuin login` or sync fails instead of uploading. Do not
  log in; enabling sync would upload threads too.
- Thread capture needs the daemon, which `autostart` manages. A running daemon
  keeps its settings; restart it after changing `[daemon]` or `[threads]`.
- `capture_tools` defaults to on: tool inputs and outputs are stored with
  secrets redacted. Set it to `false` to keep only tool names.
- `atuin resume` picks a captured thread and resumes it in its agent;
  `--print` shows the command, `--fork` and `--in <agent>` copy it instead.
- The up arrow opens Atuin search, and `enter_accept` runs the selection
  immediately; press Tab to edit it first.
