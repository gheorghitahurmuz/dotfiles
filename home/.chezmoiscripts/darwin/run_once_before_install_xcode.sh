#!/usr/bin/env bash

# set -eufo pipefail

if ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install
fi
