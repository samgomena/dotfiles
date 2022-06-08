#!/bin/bash

set -exo pipefail

# Install intellij
sudo snap install pycharm-professional --classic
sudo snap refresh pycharm-professional

VERSION=$(snap list --unicode never | grep pycharm-professional | tr -s ' ' | cut -d ' ' -f2)

# See: https://intellij-support.jetbrains.com/hc/en-us/articles/206544519
# And: https://www.jetbrains.com/help/idea/directories-used-by-the-ide-to-store-settings-caches-plugins-and-logs.html#plugins-directory
PLUGINS_DIR="$HOME/.local/share/JetBrains/PyCharm$VERSION"
PLUGINS=(
  # Code with me: https://plugins.jetbrains.com/plugin/14896-code-with-me
  14896
  # Cloud code: https://plugins.jetbrains.com/plugin/8079-cloud-code
  8079
  # Go template: https://plugins.jetbrains.com/plugin/10581-go-template
  10581
  # Graphql: https://plugins.jetbrains.com/plugin/8097-graphql
  8097
  # Kubernetes: https://plugins.jetbrains.com/plugin/10485-kubernetes
  10485
  # Makefile: https://plugins.jetbrains.com/plugin/9333-makefile-language
  9333
  # Terraform and HCL: https://plugins.jetbrains.com/plugin/7808-terraform-and-hcl
  7808
  # Toml: https://plugins.jetbrains.com/plugin/8195-toml
  8195
)

# Create plugins directory if it doesn't exist
mkdir -p "$PLUGINS_DIR"

TMP_PLUGINS_DIR=pycharm-plugins
mkdir -p $TMP_PLUGINS_DIR
pushd $TMP_PLUGINS_DIR

for plugin in "${PLUGINS[@]}"; do
  FILEPATH=$(curl -fsSL "https://plugins.jetbrains.com/api/plugins/$plugin/updates" | jq -r '.[-1].file')
  FILENAME=$(echo "$FILEPATH" | cut -d '/' -f3)
  echo "[NOTICE] Installing plugin: $FILENAME"
  wget -q "https://plugins.jetbrains.com/files/$FILEPATH"
  unzip -quo "$FILENAME" -d "$PLUGINS_DIR"
done

popd
rm -rf $TMP_PLUGINS_DIR
