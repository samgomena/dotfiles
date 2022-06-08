#!/bin/bash

set -euxo pipefail

# Non-interactive shell
export DEBIAN_FRONTEND=noninteractive
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

# Wait for apt-get lock to be released, in the event it was even created
echo "Waiting for apt-get lock to be released..."
while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
    echo "Waiting..."
    sleep 5
done

echo "The apt-get lock is free; continuing..."

sudo apt-get -y -qq update

# Install common build utilities and tools
sudo apt-get -y -q install \
    apt-transport-https \
    bash-completion \
    build-essential \
    ca-certificates \
    curl \
    dkms \
    git \
    gnupg \
    jq \
    linux-headers-generic \
    lsb-release \
    pkg-config \
    sed \
    shellcheck \
    software-properties-common \
    unzip \
    vim \
    wget

# Updates again
sudo apt-get -y -qq update
sudo DEBIAN_FRONTEND=noninteractive apt-get -qy -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

# Setup directories for other tools that will be installed
mkdir -p ~/.aws
mkdir -p ~/.certs.d
mkdir -p ~/.creds.d
mkdir -p ~/.local/bin
