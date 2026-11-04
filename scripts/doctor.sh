#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failures=0

ok() { printf 'OK   %s\n' "$*"; }
warn() { printf 'WARN %s\n' "$*"; }
fail() {
    printf 'FAIL %s\n' "$*"
    failures=$((failures + 1))
}

check_platform() {
    if [[ "$(uname -s)" == Darwin ]]; then
        ok 'macOS detected.'
    else
        fail 'The installer supports macOS only.'
    fi
}

check_home() {
    if [[ -d "$HOME" && -w "$HOME" ]]; then
        ok "Home directory is writable: $HOME"
    else
        fail "Home directory is missing or not writable: $HOME"
    fi
}

check_tools() {
    local brew_bin tool

    # Homebrew may be installed before its shell environment has been loaded.
    for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if ! command -v brew >/dev/null 2>&1 && [[ -x "$brew_bin" ]]; then
            export PATH="$(dirname "$brew_bin"):$PATH"
        fi
    done

    for tool in brew git; do
        if command -v "$tool" >/dev/null 2>&1; then
            ok "$tool is available."
        else
            warn "$tool is missing; install.sh will install it."
        fi
    done
}

check_config_overrides() {
    # This repository uses the XDG Git config. A legacy config takes precedence.
    if [[ -e "$HOME/.gitconfig" || -L "$HOME/.gitconfig" ]]; then
        warn "Existing $HOME/.gitconfig can override packages/git/.config/git/config. Review and merge your settings manually."
    fi
    if [[ -n "${XDG_CONFIG_HOME:-}" && "$XDG_CONFIG_HOME" != "$HOME/.config" ]]; then
        warn "XDG_CONFIG_HOME=$XDG_CONFIG_HOME; dotfiles are linked under $HOME/.config."
    fi
}

check_stow_conflicts() {
    local package
    local packages=()

    if ! command -v stow >/dev/null 2>&1; then
        fail 'GNU Stow is missing; conflict checks could not run. Install it with brew install stow, then rerun bash scripts/doctor.sh.'
        return 0
    fi

    for package in "$repo_dir"/packages/*/; do
        [[ -d "$package" ]] || continue
        package="${package%/}"
        packages+=("${package##*/}")
    done
    if [[ ${#packages[@]} -eq 0 ]]; then
        fail 'No Stow packages found.'
        return 0
    fi

    if (cd "$repo_dir" && stow --simulate --verbose --no-folding --restow \
        --dir="$repo_dir/packages" --target="$HOME" "${packages[@]}"); then
        ok 'All Stow packages can be applied without conflicts.'
    else
        fail 'Stow preflight failed (see details above). Back up and move conflicting files manually, then rerun bash scripts/doctor.sh. No files were changed.'
    fi
}

report_result() {
    printf '\n'
    if [[ "$failures" -gt 0 ]]; then
        printf 'Doctor found %s blocking issue(s).\n' "$failures"
        return 1
    fi
    printf 'Doctor passed. Review any warnings above before continuing.\n'
}

main() {
    check_platform
    check_home
    check_tools
    check_config_overrides
    check_stow_conflicts
    report_result
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
