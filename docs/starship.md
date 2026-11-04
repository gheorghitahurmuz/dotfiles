# Starship

Configuration: `~/.config/starship.toml`.

Diagnose from the directory where the prompt behaves unexpectedly:

```sh
starship explain
starship module nodejs
starship module git_status
starship timings
```

- Modules depend on project files and available commands.
- Disabling `package` does not disable language modules.
- Check the slow module before increasing `command_timeout`.
- For detailed logs, run `env STARSHIP_LOG=trace starship timings`.
- Missing icons usually require selecting a Nerd Font in the terminal.
