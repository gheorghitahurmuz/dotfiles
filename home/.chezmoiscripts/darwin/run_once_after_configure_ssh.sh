#!/usr/bin/env bash

set -eufo pipefail

echo 'Have you add the ssh (y/n)? '
read answer

if [ "$answer" != "${answer#[Yy]}" ]; then
    eval "$(ssh-agent -s)" && ssh-add --apple-use-keychain "$HOME/.ssh/id_rsa"
fi
