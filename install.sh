#!/usr/bin/env bash
set -euo pipefail

default_repo_dir="$HOME/Developer/dotfiles"
repo_url="${DOTFILES_REPO_URL:-https://github.com/gheorghitahurmuz/dotfiles.git}"

require_macos() {
    if [[ "$(uname -s)" != "Darwin" ]]; then
        echo "This installer currently supports macOS only."
        exit 1
    fi
}

ensure_homebrew() {
    if command -v brew >/dev/null 2>&1; then
        return
    fi

    echo "Installing Homebrew..."
    local installer
    installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || return 1
    /bin/bash -c "$installer"
}

load_homebrew() {
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
}

ensure_dotfiles_repo() {
    # BASH_SOURCE is empty when the installer runs through bash -c or a pipe.
    local script_source="${BASH_SOURCE[0]:-}" script_dir
    if [[ -n "$script_source" ]]; then
        script_dir="$(cd "$(dirname "$script_source")" && pwd)" || return 1
        if [[ -f "$script_dir/.stowrc" && -d "$script_dir/packages" ]]; then
            validate_repo "$script_dir" || return 1
            printf "%s\n" "$script_dir"
            return
        fi
    fi

    local repo_dir="${DOTFILES_DIR:-$default_repo_dir}"

    if [[ -e "$repo_dir/.git" ]]; then
        validate_repo "$repo_dir" || return 1
        printf "%s\n" "$repo_dir"
        return
    fi

    if [[ -e "$repo_dir" ]]; then
        echo "$repo_dir already exists but is not a Git repository." >&2
        exit 1
    fi

    echo "Cloning dotfiles into $repo_dir..." >&2
    mkdir -p "$(dirname "$repo_dir")" || return 1
    if ! git clone "$repo_url" "$repo_dir" >&2; then
        echo "Failed to clone dotfiles into $repo_dir." >&2
        return 1
    fi
    validate_repo "$repo_dir" || return 1
    printf "%s\n" "$repo_dir"
}

validate_repo() {
    local root="$1" file
    for file in \
        .stowrc \
        packages/homebrew/.config/Brewfile \
        scripts/doctor.sh \
        scripts/macos.sh; do
        if [[ ! -f "$root/$file" ]]; then
            echo "Invalid dotfiles repository: missing $root/$file." >&2
            return 1
        fi
    done
}

install_homebrew_packages() {
    local brewfile="$1" mas_ids

    if [[ "$(sysctl -n kern.hv_vmm_present 2>/dev/null || true)" == 1 ]]; then
        echo "Virtual machine detected: skipping App Store apps (not verified)."
        mas_ids="$(sed -n 's/^mas .*id: //p' "$brewfile")" || return 1
        export HOMEBREW_BUNDLE_MAS_SKIP="${HOMEBREW_BUNDLE_MAS_SKIP:-} $mas_ids"
    fi

    echo "Installing Homebrew packages without upgrading existing packages..."
    brew bundle install --no-upgrade --file="$brewfile"
}

ensure_stow() {
    if command -v stow >/dev/null 2>&1; then
        return
    fi

    echo "Installing GNU Stow..."
    brew install stow
}

stow_packages() (
    local repo_dir="$1"

    echo "Linking dotfiles..."

    cd "$repo_dir"

    local package
    local packages=()
    for package in packages/*/; do
        [[ -d "$package" ]] || continue
        package="${package%/}"
        package="${package#packages/}"
        packages+=("$package")
    done
    if [[ ${#packages[@]} -eq 0 ]]; then
        echo "No Stow packages found in $repo_dir/packages." >&2
        return 1
    fi
    stow --no-folding --restow --dir="$repo_dir/packages" --target="$HOME" "${packages[@]}"
)

main() {
    local repo_dir

    require_macos
    ensure_homebrew
    load_homebrew
    repo_dir="$(ensure_dotfiles_repo)"
    ensure_stow
    bash "$repo_dir/scripts/doctor.sh"
    install_homebrew_packages "$repo_dir/packages/homebrew/.config/Brewfile"
    stow_packages "$repo_dir"
    bash "$repo_dir/scripts/macos.sh"
}

if [[ -z "${BASH_SOURCE[0]:-}" || "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
