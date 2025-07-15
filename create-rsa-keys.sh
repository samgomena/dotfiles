#! /bin/bash

hostname=$(hostname | cut -d. -f1 | tr '[:upper:]' '[:lower:]')

public_github_key_name="${hostname}_github_com_rsa"
general_key_name="${hostname}_rsa"

KEYNAMES=(public_github_key_name general_key_name)

for key in "${KEYNAMES[@]}"; do
    ssh-keygen -b 4096 -t rsa -C "$key" -p "" -f "$HOME/.ssh/$key"
done