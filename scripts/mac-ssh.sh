#!/usr/bin/env bash

SSH_DIR="${HOME}/.ssh"
SSH_PUBLIC_KEY_FILE="${SSH_DIR}/id_rsa.base.pub"
SSH_PRIVATE_KEY_FILE="${SSH_DIR}/id_rsa.base"
SSH_CONFIG_FILE="${SSH_DIR}/config"
KEY="y"

if [ ! -d "$SSH_DIR" ]; then
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"

    touch "${SSH_PUBLIC_KEY_FILE}"
    chmod 644 "${SSH_PUBLIC_KEY_FILE}"

    touch "${SSH_PRIVATE_KEY_FILE}"
    chmod 600 "${SSH_PRIVATE_KEY_FILE}"

    cat <<EOF >"${SSH_CONFIG_FILE}"
Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ${SSH_PRIVATE_KEY_FILE}
EOF
    chmod 600 "${SSH_CONFIG_FILE}"

    read -rp "Add your ssh keys and then press ${KEY}: " answer
    if [ "${answer}" = "${KEY}" ]; then
        eval "$(ssh-agent -s)"
        ssh-add --apple-use-keychain "${SSH_PRIVATE_KEY_FILE}"
        ssh-add -L
    fi
fi
