#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$repo_dir/packages/git/.config/git"
target_dir="$HOME/.config/git"

check_only=

check_tree() {
    local source="$1"
    local target="$2"
    local entry
    [[ -e "$target" || -L "$target" ]] || return 0
    if [[ "$target" -ef "$source" ]] && [[ "$check_only" == --check || -L "$target" ]]; then
        return 0
    fi
    if [[ -d "$source" && ! -L "$source" && -d "$target" && ! -L "$target" ]]; then
        for entry in "$source"/* "$source"/.[!.]* "$source"/..?*; do
            [[ -e "$entry" || -L "$entry" ]] || continue
            check_tree "$entry" "$target/${entry##*/}" || return 1
        done
        return 0
    fi
    echo "Cannot migrate $source: $target already exists. Reconcile manually; both copies were preserved." >&2
    return 1
}

move_tree() {
    local source="$1"
    local target="$2"
    local entry
    if [[ -d "$source" && ! -L "$source" && -d "$target" && ! -L "$target" ]]; then
        for entry in "$source"/* "$source"/.[!.]* "$source"/..?*; do
            [[ -e "$entry" || -L "$entry" ]] || continue
            move_tree "$entry" "$target/${entry##*/}" || return 1
        done
        rmdir "$source"
    else
        # Replace only a link verified to point to this exact source.
        if [[ -L "$target" ]]; then
            rm "$target" || return 1
        fi
        mv "$source" "$target"
    fi
}

check_migration() {
    local name source_path target_path tracked
    for name in local.gitconfig identities; do
        source_path="$source_dir/$name"
        target_path="$target_dir/$name"
        [[ -e "$source_path" || -L "$source_path" ]] || continue
        tracked="$(git -C "$repo_dir" ls-files -- "packages/git/.config/git/$name")" || return 1
        if [[ -n "$tracked" ]]; then
            echo "Cannot migrate tracked Git identity files: $source_path. Untrack them first." >&2
            return 1
        fi
        check_tree "$source_path" "$target_path" || return 1
    done
}

migrate_local_config() {
    local name source_path target_path
    for name in local.gitconfig identities; do
        source_path="$source_dir/$name"
        target_path="$target_dir/$name"
        [[ -e "$source_path" || -L "$source_path" ]] || continue
        move_tree "$source_path" "$target_path" || return 1
        echo "Moved local Git configuration to $target_path."
    done
}

main() {
    check_only="${1:-}"

    # Restow must unfold directory links before any files can move.
    if [[ "$check_only" != --check ]] && [[ -L "$HOME/.config" || -L "$target_dir" ]]; then
        echo "Git local migration requires real configuration directories. Run the installer to restow first." >&2
        return 1
    fi

    check_migration || return 1
    if [[ "$check_only" == --check ]]; then
        return 0
    fi
    migrate_local_config
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
