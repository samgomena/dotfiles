#!/bin/bash

set -euxo pipefail

# Non-interactive shell
export DEBIAN_FRONTEND=noninteractive

# Install vscode
sudo snap install code --classic
sudo snap refresh code

# Add Code extensions
extensions=(
    'bungcip.better-toml'
    'davidanson.vscode-markdownlint'
    'eamodio.gitlens'
    'eg2.vscode-npm-script'
    'golang.go'
    'googlecloudtools.cloudcode'
    'graphql.vscode-graphql'
    'hashicorp.terraform'
    'marcostazi.vs-code-vagrantfile'
    'ms-azuretools.vscode-docker'
    'ms-kubernetes-tools.vscode-kubernetes-tools'
    'ms-python.python'
    'ms-python.vscode-pylance'
    'ms-vscode-remote.vscode-remote-extensionpack'
    'ms-vscode.cpptools'
    'ms-vsliveshare.vsliveshare'
    'redhat.vscode-yaml'
    'rust-lang.rust'
    'ryu1kn.partial-diff'
    'serayuzgur.crates'
    'sonarsource.sonarlint-vscode'
    'timonwong.shellcheck'
    'webfreak.debug'
    'yzhang.markdown-all-in-one'
)
for ext in "${extensions[@]}"
do
    code --install-extension "$ext"
done