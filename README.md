# dotfiles

- chezmoi
- homebrew

## Prerequisites
On MacOS:
```sh
xcode-select --install
```

## Install chezmoi and dotfiles on a new machine
```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply gheorghitahurmuz
```

## Fonts:
  - MonoLisa
  - Fira Code
  - Symbols Nerd Font Mono

Check [this](https://sw.kovidgoyal.net/kitty/faq/#kitty-is-not-able-to-use-my-favorite-font) and [this](https://github.com/MonoLisaFont/feedback/issues/53#issuecomment-1336163548)


## Good practices in shell scripting

### Specify the Bash Interpreter
To start a Bash script, it's a good practice to use a shebang line to specify the Bash interpreter. You can use the following line at the beginning of your script:

`#!/usr/bin/env bash`

### Prevent Errors

`set -eufo pipefail`

Here's what each part of this line does:
  - e: This option causes the script to exit immediately if any command within it exits with a non-zero status, which helps catch errors early.
  - u: It treats the use of unset variables as errors, helping to avoid accidental use of uninitialized variables.
  - o pipefail: This part ensures that if any command in a pipeline (commands connected by "|") fails, the pipeline as a whole returns a non-zero status, ensuring proper error handling.

For more info, see [this gist](https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425)
