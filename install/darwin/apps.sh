#!/usr/bin/env bash

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

function _brew() {
    if command -v brew &> /dev/null; then
        command brew "$@"
        return $?
    fi

    local brew_path
    case "$(uname -m)" in
        arm64)
            brew_path="/opt/homebrew/bin/brew"
            ;;
        x86_64)
            brew_path="/usr/local/bin/brew"
            ;;
        *)
            echo "Error: Homebrew path not set for architecture $(uname -m)." >&2
            return 1
            ;;
    esac

    if [[ -x "$brew_path" ]]; then
        "$brew_path" "$@"
        return $?
    else
        echo "Error: Homebrew not found at $brew_path." >&2
        return 1
    fi
}

function configure() {
    export HOMEBREW_DOTFILE_PERSONAL_DEVICE=$DOTFILE_PERSONAL_DEVICE

    # Set up Homebrew environment (PATH, etc.) for this script's session
    if ! command -v brew &> /dev/null; then
        eval "$(_brew shellenv)"
    fi
}

function install_apps() {
    set +e
    brew bundle --global --force
    set -e
}

function cleanup() {
    brew cleanup
}

function main() {
    configure
    install_apps
    cleanup
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
