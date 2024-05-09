#!/usr/bin/env bash

# set -eufo pipefail

is_installed = $(xcode-select -p >/dev/null 2>&1; echo $?)

if ! $is_installed; then
    install = $(xcode-select --install)
    read installed
fi
