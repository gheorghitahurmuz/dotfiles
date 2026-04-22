#!/bin/bash

# Homebrew PATH — needed because Ghostty launches this before shell profile
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

SESSION="main"

tmux has-session -t $SESSION 2>/dev/null \
  && tmux attach-session -t $SESSION \
  || tmux new-session -s $SESSION
