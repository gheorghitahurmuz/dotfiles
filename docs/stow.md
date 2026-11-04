# Stow

Run from the repository root. Link one package:

```sh
stow --restow zsh
```

Check installation readiness without changing files:

```sh
bash scripts/doctor.sh
```

Doctor needs Stow installed and checks all packages together. Blocking issues
return exit code 1; warnings do not block installation.

Back up and reconcile conflicting files before linking. `stow --adopt` moves
existing files into the repository and can replace its configuration.

Configuration targets `~/.config`; a different `XDG_CONFIG_HOME` needs review.

Directory folding is disabled so local files stay outside the repository.
The installer restows old links and moves untracked Git identity files into the
real `~/.config/git` directory. Conflicting or tracked files stop migration.
