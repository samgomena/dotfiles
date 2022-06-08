#!/bin/bash

set -euxo pipefail

# Add Hashicorp's GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

# Add official Hashicorp repository
sudo apt-add-repository -y "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Install vault and terraform
sudo apt-get update -y -qq
sudo apt-get install terraform vagrant vault
