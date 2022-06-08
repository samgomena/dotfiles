#!/bin/bash

set -exo pipefail

# Non-interactive shell
export DEBIAN_FRONTEND=noninteractive

# Cleanup to ensure pyenv installation is idempotent
[ -d "$HOME/.pyenv" ] && rm -rf "$HOME"/.pyenv

# Install packages required for building python
# See: https://github.com/pyenv/pyenv/wiki/Common-build-problems
sudo apt-get update -y -qq
sudo apt-get install -y \
  libbz2-dev \
  libffi-dev \
  liblzma-dev \
  libncursesw5-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  libxml2-dev \
  libxmlsec1-dev \
  llvm \
  tk-dev \
  xz-utils \
  zlib1g-dev

# Install pyenv
# See: https://github.com/pyenv/pyenv-installer#pyenv-installer
curl -fsSL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

# Initial pyenv environment configuration
if [[ ":$PATH:" == *":$HOME/.pyenv/bin:"* ]]; then
    echo "pyenv is already set on the PATH"
else
    # shellcheck disable=SC2016
    echo 'PATH="$PATH:$HOME/.pyenv/bin"' | tee -a ~/.bashrc

    # Initialize pyenv for shims and auto-completion
    tee -a ~/.bashrc << "EOF"

# Initialize pyenv
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
EOF
fi

# Temporarily update path and environment for this script
export PATH="$PATH:$HOME/.pyenv/bin"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

pyenv update

pyenv install 3.9.9
pyenv global 3.9.9

# Upgrade pip, setuptools; install pipx to user (i.e. to ~/.local)
python3.9 -m pip install --upgrade pip setuptools
python3 -m pip install --user pipx

if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
    echo "pipx binaries are already set on the PATH"
else
    # shellcheck disable=SC2016
    echo 'PATH="$PATH:$HOME/.local/bin"' | tee -a ~/.bashrc

    # Eval pipx completions in bashrc
    tee -a ~/.bashrc << "EOF"

# Eval pipx completions in bashrc
eval "$(register-python-argcomplete pipx)"
EOF
fi

# Temporarily update path and environment for this script
export PATH="$PATH:$HOME/.local/bin"
eval "$(register-python-argcomplete pipx)"

python_packages=(
    black
    cowsay
    pipenv
    pre-commit
)

for package in "${python_packages[@]}"
do
    pipx install --force "$package"
done