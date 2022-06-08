#!/bin/bash

set -euxo pipefail

# Install docker on ubuntu
# At the time of writing this scripts installs docker on Ubuntu versions
# 
# - Ubuntu Impish 21.10
# - Ubuntu Hirsute 21.04
# - Ubuntu Focal 20.04 (LTS)
# - Ubuntu Bionic 18.04 (LTS)
#
# Docs: https://docs.docker.com/engine/install/ubuntu/

sudo apt-get -y -qq update

# Set up Dockers repository to download from
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get -y -qq update

# Uninstall old versions first
sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get -y install docker-ce docker-ce-cli containerd.io

# Install docker compose plugin (compose v2)
# See: https://docs.docker.com/compose/cli-command/#installing-compose-v2
mkdir -p ~/.docker/cli-plugins/
version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)
curl -sL "https://github.com/docker/compose/releases/download/$version/docker-compose-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

# Install docker in rootless mode
# See: https://docs.docker.com/engine/security/rootless/
# TODO: Parameterize this probably
# if [ -n "$INSTALL_DOCKER_ROOTLESS" ]; then
#     sudo apt-get install -y dbus-user-session uidmap
#     dockerd-rootless-setuptool.sh install

#     echo "export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock" >> ~/.bashrc

#     # Enable docker daemon and launch it on startup
#     systemctl --user enable docker
#     sudo loginctl enable-linger "$(whoami)"
# fi

# TODO: This needs to be updated to point to whatever the internal docker repos are
exit 0;

daemon_config=/etc/docker/daemon.json

# Configure internal docker hub registry mirrors
if [ -f "$daemon_config" ]; then
    # Ensure docker configuration is idempotent
    sudo rm -f $daemon_config.tmp

    # Configuration already exists; add new keys to it, making sure to keep existing values and remove duplicates
    sudo jq '.["registry-mirrors"] |= (. + ["https://<internal-docker-repo.company.com>"] | unique)' \
        $daemon_config | sudo tee -a $daemon_config.tmp
    sudo cp $daemon_config.tmp $daemon_config

    # Redo the update process for next key/val
    sudo rm -f $daemon_config.tmp
    sudo jq '.["insecure-registries"] |= (. + ["<internal-docker-repo-1.company.com>","<internal-docker-repo-2.company.com>","<internal-docker-repo-3.company.com>","<internal-docker-repo-4.company.com>"] | unique)' \
        $daemon_config | sudo tee -a $daemon_config.tmp
    sudo cp $daemon_config.tmp $daemon_config
else
    # No configuration file exists; create one
    sudo mkdir -p /etc/docker
    echo '{
        "insecure-registries": [
            "<internal-docker-repo-1.company.com>",
            "<internal-docker-repo-2.company.com>",
            "<internal-docker-repo-3.company.com>",
            "<internal-docker-repo-4.company.com>"
        ],
        "registry-mirrors": ["https://<internal-docker-repo.company.com>"] 
    }' | sudo tee -a $daemon_config
fi