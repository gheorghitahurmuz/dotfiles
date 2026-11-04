# Neovim

Requires Neovim 0.12+ and Git. On first launch, confirm the Night Owl download
requested by the built-in `vim.pack` manager. Network access is needed then.

- `Space e`: toggle the netrw tree sidebar; `Enter` opens a file or directory.
- `Ctrl-w w`: switch between the tree and the editor.
- `:lua vim.pack.update()`: review plugin updates; `:write` applies them.

Plugins live under `~/.local/share/nvim`. The generated
`~/.config/nvim/nvim-pack-lock.json` stays local; new machines initially use
the theme's current default branch.

[vim.pack](https://neovim.io/doc/user/pack/) documents installation and update
confirmation. [Night Owl](https://github.com/oxfist/night-owl.nvim) provides
the theme and its default setup.
