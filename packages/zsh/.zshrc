typeset -U path
path=("$HOME/.local/bin" $path)

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INTERACTIVE_COMMENTS
setopt SHARE_HISTORY

alias reload_zsh='exec zsh'
alias git_root='cd "$(git rev-parse --show-toplevel)"'

export HOMEBREW_BUNDLE_FILE="${HOME}/.config/Brewfile"

if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

autoload -Uz compinit
compinit

if (( $+commands[eza] )); then
    alias ls="eza --grid --color auto --icons --sort=type"
    alias ll="eza --long --color always --icons --sort=type"
    alias la="eza --grid --all --color auto --icons --sort=type"
    alias lla="eza --long --all --color auto --icons --sort=type"
fi

if (( $+commands[bat] )); then
    alias cat=bat
fi

if (( $+commands[nvim] )); then
    export MANPAGER="nvim +Man!"
    alias vim=nvim
fi

if (( $+commands[mise] )); then
    if [[ "$TERM_PROGRAM" == "vscode" ]]; then
        eval "$(mise activate zsh --shims)"
    else
        eval "$(mise activate zsh)"
    fi
fi

if (( $+commands[zoxide] )); then
    export _ZO_DATA_DIR="$HOME/.local/share"
    export _ZO_ECHO=1
    alias cd=z
    eval "$(zoxide init zsh)"
fi

if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
fi

if (( $+commands[atuin] )); then
    eval "$(atuin init zsh --disable-up-arrow)"
fi

if [[ -f "$HOME/.zshrc.local" && -r "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi

if [[ -n "$HOMEBREW_PREFIX" ]]; then
    if [[ -r "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
        source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
        bindkey '^F' autosuggest-accept
    fi
fi

if [[ -n "$HOMEBREW_PREFIX" ]]; then
    [[ -r "$HOMEBREW_PREFIX/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]] &&
        source "$HOMEBREW_PREFIX/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
fi
