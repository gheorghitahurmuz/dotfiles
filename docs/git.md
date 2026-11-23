# Git

## Local identity

Keep names and emails outside the repository:

```sh
mkdir -p ~/.config/git/identities
git config --file ~/.config/git/identities/personal.gitconfig user.name "Your Name"
git config --file ~/.config/git/identities/personal.gitconfig user.email "you@example.com"
```

Map repository directories in `~/.config/git/local.gitconfig`. Start from the
example, which covers personal, dotfiles, and work:

```sh
cp -i docs/local.gitconfig.example ~/.config/git/local.gitconfig
```

The trailing slash includes nested repositories. Add a separate identity and
rule for each client.

Unmatched repositories have no default identity; Git refuses to guess one.
Check from inside a repository:

```sh
git config --show-origin --get user.name
git config --show-origin --get user.email
```

An existing `~/.gitconfig` can override these settings. Review it manually.

## Review changes

Use `git difftool -- path/to/file` for unstaged changes or
`git difftool --staged -- path/to/file` for staged changes. Neovim opens a
side-by-side diff. Use `]c` and `[c` to move between hunks and `:qa` to close
the comparison.

## GitHub authentication

```sh
gh auth login
gh auth status
```

Add scopes when needed:

```sh
gh auth refresh --hostname github.com --scopes "workflow,read:packages"
```

With multiple accounts, select one using `gh auth switch --hostname github.com`.
The credential helper uses HTTPS and runs `gh` from `PATH`.
