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

function is_homebrew_installed() {
    local brew_path
    brew_path=$(detect_homebrew_path) || return 1
    [[ -x "$brew_path" ]]
}

function setup_homebrew_env() {
    local brew_path
    brew_path=$(detect_homebrew_path) || return 1
    
    if [[ -x "$brew_path" ]]; then
        eval "$("$brew_path" shellenv)"
    else
        echo "Error: Homebrew not found at $brew_path" >&2
        return 1
    fi
}

function install_homebrew() {
    if is_homebrew_installed; then
        echo "Homebrew is already installed"
        return 0
    fi
    
    echo "Installing Homebrew..."
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        echo "Homebrew installed successfully"
    else
        echo "Homebrew installation failed" >&2
        return 1
    fi
}

function opt_out_of_analytics() {
    if command -v brew &>/dev/null; then
        echo "Disabling Homebrew analytics..."
        brew analytics off
        echo "Analytics disabled"
    else
        echo "Warning: brew command not found, skipping analytics opt-out" >&2
        return 1
    fi
}

function verify_installation() {
    if command -v brew &>/dev/null; then
        local version
        version=$(brew --version | head -n1)
        echo "Homebrew verification successful: $version"
        return 0
    else
        echo "Homebrew verification failed: brew command not available" >&2
        return 1
    fi
}

function main() {
    echo "=== Homebrew Setup ==="
    echo ""
    
    install_homebrew || exit 1
    setup_homebrew_env || exit 1
    verify_installation || exit 1
    opt_out_of_analytics || echo "Warning: Failed to disable analytics"
    
    echo ""
    echo "=== Setup Complete ==="
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi