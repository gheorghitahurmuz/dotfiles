#!/usr/bin/env bash

set -eufo pipefail

command -v xcode-select -p >/dev/null 2>&1 || \
    xcode-select --install