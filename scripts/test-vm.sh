#!/bin/bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ensure_baseline() {
    if [[ "$base" == macos-clean ]] && ! tart list --source local --quiet | grep -Fxq macos-clean; then
        tart clone ghcr.io/cirruslabs/macos-tahoe-vanilla:latest macos-clean
    fi

    if ! tart list --source local --format json |
        jq -e --arg base "$base" 'any(.[]; .Name == $base and .State == "stopped")' >/dev/null; then
        echo "Baseline $base must be a stopped local VM." >&2
        return 1
    fi
}

start_vm() {
    # Keep the baseline intact and leave the test VM open for manual checks.
    tart clone "$base" "$vm"
    tart run "$vm" &
    ip="$(tart ip "$vm" --wait 180)"
}

wait_for_ssh() {
    local attempt
    for ((attempt = 0; attempt < 60; attempt++)); do
        if nc -z -w 1 "$ip" 22 2>/dev/null; then
            return 0
        fi
        sleep 2
    done
    if ! nc -z -w 1 "$ip" 22; then
        echo 'SSH is not ready.' >&2
        return 1
    fi
}

configure_ssh() {
    ssh_control_dir="$(mktemp -d /tmp/dotfiles-ssh.XXXXXX)"
    ssh_options=(-o "HostKeyAlias=$vm" -o ConnectTimeout=5 -o ConnectionAttempts=5
        -o ControlMaster=auto -o ControlPersist=300 -o "ControlPath=$ssh_control_dir/socket")
    guest="${VM_USER:-admin}@$ip"
    trap cleanup_ssh EXIT
}

cleanup_ssh() {
    /usr/bin/ssh "${ssh_options[@]}" -O exit "$guest" >/dev/null 2>&1 || true
    rm -rf "$ssh_control_dir"
}

check_guest() {
    /usr/bin/ssh "${ssh_options[@]}" "$guest" /bin/bash -s <<'GUEST_CHECK'
set -euo pipefail
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
for candidate in \
    /opt/homebrew/bin/brew \
    /usr/local/bin/brew \
    "$HOME/Developer/dotfiles" \
    "$HOME/.config/Brewfile" \
    "$HOME/.zshrc"; do
    if [[ -e "$candidate" || -L "$candidate" ]]; then
        echo "Baseline is not clean: $candidate already exists." >&2
        exit 1
    fi
done
if ! mounts="$(/sbin/mount)"; then
    echo "Could not inspect guest mounts." >&2
    exit 1
fi
if [[ "$mounts" == *virtiofs* ]]; then
    echo "Guest has shared host folders; remove sharing before bootstrap testing." >&2
    exit 1
fi
if command -v brew >/dev/null 2>&1; then
    echo "Baseline is not clean: Homebrew is already available." >&2
    exit 1
fi
console_user="$(/usr/bin/stat -f %Su /dev/console)" || exit 1
guest_user="$(/usr/bin/id -un)" || exit 1
if [[ -z "$console_user" || -z "$guest_user" || "$console_user" != "$guest_user" ]]; then
    echo "Log into the guest desktop before testing installation." >&2
    exit 1
fi
GUEST_CHECK
}

copy_checkout() {
    # Copy current files onto the guest disk, excluding private overrides.
    COPYFILE_DISABLE=1 tar -czf - -C "$root" \
        --exclude='.DS_Store' --exclude='Brewfile.local' \
        --exclude='local.gitconfig' --exclude='identities' \
        install.sh .stowrc packages scripts | \
        /usr/bin/ssh "${ssh_options[@]}" "$guest" \
        'export PATH=/usr/bin:/bin:/usr/sbin:/sbin
         test ! -e ~/Developer/dotfiles &&
         mkdir -p ~/Developer/dotfiles &&
         tar -xzf - -C ~/Developer/dotfiles'
}

install_guest() {
    /usr/bin/ssh "${ssh_options[@]}" -t "$guest" \
        'export PATH=/usr/bin:/bin:/usr/sbin:/sbin; cd ~/Developer/dotfiles &&
         export HOMEBREW_BUNDLE_MAS_SKIP="$(sed -n "s/^mas .*id: //p" packages/homebrew/.config/Brewfile)" &&
         bash install.sh'
}

main() {
    if [[ $# -gt 1 ]]; then
        echo "Usage: bash scripts/test-vm.sh [BASE_VM]" >&2
        return 1
    fi

    base="${1:-macos-clean}"
    vm="dotfiles-$(date +%Y%m%d-%H%M%S)"
    ensure_baseline
    start_vm
    wait_for_ssh
    configure_ssh
    check_guest
    copy_checkout
    install_guest
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
