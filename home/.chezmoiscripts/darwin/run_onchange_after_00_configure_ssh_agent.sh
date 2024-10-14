#!/usr/bin/env bash

set -euo pipefail

echo "==> 📜 Configure SSH"

eval "$(ssh-agent -s)"

if /usr/bin/ssh-add --apple-use-keychain "$HOME/.ssh/id_rsa"; then
    echo "SSH key added successfully."
else
    echo "Failed to add SSH key."
    exit 1
fi
