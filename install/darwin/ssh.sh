#!/usr/bin/env bash

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

function configure_ssh() {
    if [ -z "${SSH_AUTH_SOCK:-}" ] || ! ssh-add -l &>/dev/null; then
        echo "Starting ssh-agent..."
        eval "$(ssh-agent -s)"
        echo "ssh-agent started"
    else
        echo "ssh-agent is already running"
    fi
    
    echo ""
    echo "=== SSH Key Setup ==="
    echo "To create a new SSH key:"
    echo "  ssh-keygen -t ed25519 -C \"your_email@example.com\""
    echo ""
    
    echo "To add your SSH key (macOS):"
    echo "  /usr/bin/ssh-add --apple-use-keychain ~/.ssh/<KEY_FILENAME>"
    
    echo ""
    echo "Don't forget to add this to ~/.ssh/config:"
    echo "  Host <HOSTNAME>"
    echo "    IdentityFile ~/.ssh/<KEY_FILENAME>"

    echo ""
    
    read -n 1 -s -r -p "Press any key to continue..."
    echo ""
}

function main() {
    configure_ssh
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi