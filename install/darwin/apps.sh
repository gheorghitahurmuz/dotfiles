#!/usr/bin/env bash

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

function detect_homebrew_path() {
    local arch
    arch=$(uname -m)
    
    if [[ "$arch" == "arm64" ]]; then
        echo "/opt/homebrew/bin/brew"
    elif [[ "$arch" == "x86_64" ]]; then
        echo "/usr/local/bin/brew"
    else
        echo "Unsupported architecture: $arch" >&2
        return 1
    fi
}

function _brew() {
    if command -v brew &>/dev/null; then
        command brew "$@"
        return $?
    fi
    
    local brew_path
    brew_path=$(detect_homebrew_path) || return 1
    
    if [[ -x "$brew_path" ]]; then
        "$brew_path" "$@"
        return $?
    else
        echo "Error: Homebrew not found at $brew_path" >&2
        echo "Please install Homebrew first: https://brew.sh" >&2
        return 1
    fi
}

function verify_homebrew() {
    if ! _brew --version &>/dev/null; then
        echo "Error: Homebrew is not installed or not working" >&2
        echo "Install it from: https://brew.sh" >&2
        return 1
    fi
    echo "Homebrew found: $(_brew --version | head -n1)"
}

function configure() {
    if [[ -n "${DOTFILE_PERSONAL_DEVICE:-}" ]]; then
        export HOMEBREW_DOTFILE_PERSONAL_DEVICE=$DOTFILE_PERSONAL_DEVICE
        echo "Personal device flag set: $DOTFILE_PERSONAL_DEVICE"
    fi
    
    # Set up Homebrew environment (PATH, etc.) for this script's session
    if ! command -v brew &>/dev/null; then
        echo "Setting up Homebrew environment..."
        eval "$(_brew shellenv)"
        echo "Homebrew environment configured"
    fi
}

function verify_brewfile() {
    local brewfile="${HOMEBREW_BUNDLE_FILE:-$HOME/.Brewfile}"
    
    if [[ ! -f "$brewfile" ]]; then
        echo "Error: Brewfile not found at $brewfile" >&2
        echo "Create one with: brew bundle dump --global" >&2
        return 1
    fi
    
    echo "Using Brewfile: $brewfile"
}

function install_apps() {
    echo ""
    echo "Installing applications from Brewfile..."
    echo "This may take a while..."
    echo ""
    
    # Temporarily disable exit on error to capture brew bundle's exit code
    local exit_code=0
    set +e
    _brew bundle --global --force
    exit_code=$?
    set -e
    
    if [[ $exit_code -eq 0 ]]; then
        echo "All applications installed successfully"
        return 0
    else
        echo "Warning: Some installations may have failed (exit code: $exit_code)" >&2
        echo "Check output above for details" >&2
        return $exit_code
    fi
}

function cleanup() {
    echo ""
    echo "Cleaning up Homebrew cache..."
    if _brew cleanup; then
        echo "Cleanup complete"
    else
        echo "Warning: Cleanup encountered issues" >&2
        return 1
    fi
}

function main() {
    echo "=== Homebrew Bundle Installation ==="
    echo ""
    
    verify_homebrew || exit 1
    configure || exit 1
    verify_brewfile || exit 1
    local install_failed=0
    install_apps || install_failed=1
    cleanup || true
    
    echo ""
    if [[ $install_failed -eq 0 ]]; then
        echo "=== Installation Complete ==="
    else
        echo "=== Installation Completed with Warnings ===" >&2
        exit 1
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi