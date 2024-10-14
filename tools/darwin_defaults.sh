#!/usr/bin/env bash

if ! (return 0 2> /dev/null); then
    set -o errexit
    set -o errtrace
    set -o nounset
    set -o pipefail
fi

old_defaults=$(mktemp)
new_defaults=$(mktemp)

error() {
    local red=$(tput setaf 1)
    local reset=$(tput sgr0)
    echo "${red}Error: ${@} ${reset}" 1>&2
}

script_trap_exit() {
   rm "${old_defaults}" "${new_defaults}"
}

init_defaults() {
    defaults read | tee "${old_defaults}" >> "${new_defaults}"
}

open_diff() {
    if ! command -v code &> /dev/null; then
        error "VS Code is not installed"
        exit 1
    fi

    code -n --diff "${old_defaults}" "${new_defaults}"
}

update_diff() {
    cat "${new_defaults}" > "${old_defaults}"
    defaults read > "${new_defaults}"
}

action() {
    PS3="Select the operation: "

    select opt in check quit; do
        case $opt in
            check)
                update_diff
            ;;
            quit)
                break
            ;;
            *)
            error "Invalid option $REPLY"
            ;;
        esac
    done

}

main() {
    trap script_trap_exit EXIT

    init_defaults
    open_diff
    action
}

if ! (return 0 2> /dev/null); then
    main "$@"
fi




