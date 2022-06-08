#!/bin/bash

set -exo pipefail

# Non-interactive shell
export DEBIAN_FRONTEND=noninteractive

# Install nvm
# See: https://github.com/nvm-sh/nvm#install--update-script
latest=$(curl --silent https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r .tag_name)
curl -fsSL -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$latest/install.sh" | bash

# Make nvm accessible for the rest of this script
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR"/nvm.sh  # This loads nvm
# shellcheck disable=SC1091
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR"/bash_completion  # This loads nvm bash_completion

# Install latest lts verison of node
nvm install --lts

# Install yarn via corepack
# node v16.10+ has it bundled; older versions have to install it from NPM
# See: https://yarnpkg.com/getting-started/install
if ! command -v corepack 1>/dev/null 2>&1; then
  npm install --global corepack
else
  corepack enable
fi