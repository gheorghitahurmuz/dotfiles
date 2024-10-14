#!/usr/bin/env bash

set -eufo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "==> 📜 Install Homebrew"

  (/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)")
  eval "$(homebrew/bin/brew shellenv)"
else
  echo "Homebrew already installed"
fi
