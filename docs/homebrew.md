# Homebrew

Keep machine-specific packages in `~/.config/Brewfile.local`:

```sh
mkdir -p ~/.config
cp -i docs/Brewfile.local.example ~/.config/Brewfile.local
```

Edit it for this Mac. It is unversioned and works before the first installation.

Install declared packages:

```sh
brew bundle install --no-upgrade
```

Review undeclared packages before removing them:

```sh
brew bundle cleanup
brew bundle cleanup --force
```

The last command removes packages without confirmation. Zsh sets
`HOMEBREW_BUNDLE_FILE=~/.config/Brewfile`; that shared Brewfile loads the local
file when present. In other shells, pass `--file="$HOME/.config/Brewfile"` explicitly.

The installer skips upgrades of existing packages. Dependencies may still require
updates. Run `brew bundle upgrade` explicitly to update declared packages.

In a VM, the installer skips App Store apps automatically using
`HOMEBREW_BUNDLE_MAS_SKIP`. Other packages install normally.
