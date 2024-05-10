#!/usr/bin/env bash

set -euo pipefail

echo "==> 📜 Configure SSH"

# Function to start the ssh-agent and add the SSH key
add_ssh_key() {
  echo "Starting ssh-agent and adding SSH key..."
  eval "$(ssh-agent -s)"
  if ssh-add --apple-use-keychain "$HOME/.ssh/id_rsa"; then
    echo "SSH key added successfully."
  else
    echo "Failed to add SSH key."
    exit 1
  fi
}

# Prompt user to check if SSH key should be added
while true; do
  read -p "Have you added the SSH key? (y/n) " answer
  case "$answer" in
  [Yy]*)
    if [[ -f "$HOME/.ssh/id_rsa" ]]; then
      add_ssh_key
    else
      echo "SSH key file not found at $HOME/.ssh/id_rsa."
      exit 1
    fi
    break
    ;;
  [Nn]*)
    echo "SSH key not added. Exiting script."
    exit 0
    ;;
  *)
    echo "Please answer yes (y) or no (n)."
    ;;
  esac
done
