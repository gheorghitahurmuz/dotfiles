export LANG="en_US.UTF-8"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
export CODEX_HOME="$XDG_CONFIG_HOME/codex"
export PI_CODING_AGENT_DIR="$XDG_CONFIG_HOME/pi"
export ATUIN_CONFIG_DIR="$XDG_CONFIG_HOME/atuin"
export ATUIN_HOME="$XDG_DATA_HOME/atuin"
export AZURE_CONFIG_DIR="$XDG_CONFIG_HOME/azure"
export RUSTUP_HOME="$XDG_CONFIG_HOME/rustup"
export NUGET_PACKAGES="$XDG_CACHE_HOME/nuget/packages"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_LOGS_DIR="$XDG_STATE_HOME/npm/logs"
export PORTLESS_STATE_DIR="$XDG_STATE_HOME/portless"
export CARGO_HOME="$XDG_CONFIG_HOME/cargo"
export BUN_INSTALL="$XDG_CONFIG_HOME/bun"
export TART_HOME="$XDG_DATA_HOME/tart"
export OLLAMA_MODELS="$XDG_DATA_HOME/ollama/models"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export LESSHISTFILE=-
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"
export NG_CLI_ANALYTICS=false
export VISUAL="${VISUAL:-nvim}"
export EDITOR="${EDITOR:-nvim}"

config_dirs=(
  "$CLAUDE_CONFIG_DIR"
  "$CODEX_HOME"
  "$PI_CODING_AGENT_DIR"
  "$ATUIN_CONFIG_DIR"
  "$AZURE_CONFIG_DIR"
  "$RUSTUP_HOME"
  "$CARGO_HOME"
  "$BUN_INSTALL"
  "$ATUIN_HOME"
  "$TART_HOME"
  "$OLLAMA_MODELS"
  "${PYTHON_HISTORY:h}"
)

for dir in "${config_dirs[@]}"; do
  [[ -d $dir ]] || mkdir -p "$dir"
done

unset config_dirs dir
