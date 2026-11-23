# Neovim

Requires Neovim 0.12+ and Git. On first launch, confirm the Night Owl download
requested by the built-in `vim.pack` manager. Network access is needed then.

- `nvim -R path/to/file` opens a file in read-only mode.
- `:edit **/prefix` followed by `Tab` completes matching filenames in
  subdirectories.
- `Space e` toggles the netrw tree. Use `Enter` to open a file or directory
  and `Ctrl-w w` to switch windows.
- `:grep pattern` searches the project from its root using ripgrep when
  available. Use `:copen` to browse matches and `:cnext` to jump to the next one.
- `:lua vim.pack.update()` reviews plugin updates. Use `:write` to apply them.

Plugins live under `~/.local/share/nvim`. The generated
`~/.config/nvim/nvim-pack-lock.json` stays local; new machines initially use
the theme's current default branch.

[vim.pack](https://neovim.io/doc/user/pack/) documents installation and update
confirmation. [Night Owl](https://github.com/oxfist/night-owl.nvim) provides
the theme and its default setup.
