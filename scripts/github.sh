#!/bin/bash

set -euxo pipefail

# This file will create a github token for your user and place it in a known location on your machine for future use
# If this is successful, this will also create an ssh key and upload it to github

BASE_URL="https://<internal-github.company.com>/api/v3"

KEYNAME="$(hostname)_${USER}_github_com_rsa"

ssh-keygen -b 4096 -t rsa -C "$KEYNAME" -f "$HOME/.ssh/$KEYNAME" -P ""

# Throw key into ssh config
mkdir -p ~/.ssh
cat >> ~/.ssh/config <<EOL

Host <internal-github.company.com>
  HostName <internal-github.company.com>
  IdentityFile ~/.ssh/${KEYNAME}
EOL

KEY="$(cat ~/.ssh/"$KEYNAME".pub)"
PAYLOAD=$(jq -n --arg t "$KEYNAME" --arg k "$KEY" '{"title": $t, "key": $k}')
ENDPOINT="$BASE_URL/user/keys"

# Expose GITHUB_TOKEN environment variable
# shellcheck disable=SC1091
source /home/vagrant/.creds.d/.gh_tokens

curl -s \
  --request POST \
  --url $ENDPOINT \
  --header "Authorization: Bearer $GITHUB_TOKEN" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --data "$PAYLOAD"
