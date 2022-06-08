#!/bin/bash

set -exo pipefail

# Convert hostname to lowercase and 
HOSTNAME=$(hostname | tr '[:upper:]' '[:lower:]' | tr '.' '_' | tr '-' '_' | tr ' ' '_')
KEYNAME="${HOSTNAME}_${USER}_blade"

ssh-keygen -b 4096 -t rsa -C "$KEYNAME" -f "$HOME/.ssh/$KEYNAME" -P ""

# Throw key into ssh config
mkdir -p ~/.ssh
cat >> ~/.ssh/config <<EOL

Host $1
  HostName $1
  User $2
  IdentityFile ~/.ssh/${KEYNAME}
EOL

ssh-copy-id -i "$HOME/.ssh/$KEYNAME" "$2@$1"