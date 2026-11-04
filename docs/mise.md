# mise

Install configured runtimes separately from dotfiles:

```sh
mise install
```

Shared runtime defaults are managed in `packages/mise/.config/mise/config.toml`.
Keep project versions in `mise.toml`; pin them when reproducibility matters.

- `latest` does not upgrade on every shell start. Run `mise upgrade` deliberately.
- Missing commands can trigger runtime downloads.
- Only Node idiomatic version files are enabled.
- VS Code terminals use shims; project environment changes do not update the
  parent shell there. Use `mise exec -- command` when needed.

Diagnose from the affected project:

```sh
mise config ls
mise ls --current
mise doctor
time mise env -s zsh
```
