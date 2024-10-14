#!/usr/bin/env bash

set -eufo pipefail

brew_path() {
    if [[ $(uname -m) == "arm64" ]]; then
        echo "/opt/homebrew/bin/brew"
    else
        echo "/usr/local/bin/brew"
    fi
}

if [[ $(command -v brew) || -x $(brew_path) ]]; then
    echo "Homebrew already installed"
else
    echo "==> 📜 Install Homebrew"

    (/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)")
    eval "$("$(brew_path)" shellenv)"
fi
