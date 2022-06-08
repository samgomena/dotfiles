#!/bin/bash

set -euxo pipefail

# Install kubectl
# See: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo \
  "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ \
  kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update -y -qq
sudo apt-get install -y -q kubectl

# cat << EOF >> ~/.bashrc 

# TODO(sgomena): Does this work?
# # Set up kubectl completions and alias
# source <(kubectl completion bash)
# alias k=kubectl
# complete -F __start_kubectl k
# EOF

# Set up completions and alias for kubectl
echo 'source <(kubectl completion bash)' >> ~/.bashrc
kubectl completion bash | sudo tee -a /etc/bash_completion.d/kubectl

echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc

# Install kubectx, kubens
# See: https://github.com/ahmetb/kubectx#manual-installation-macos-and-linux
if [ -d ~/.kubectx ]; then
  pushd ~/.kubectx
  git pull --rebase
  popd
else
  git clone https://github.com/ahmetb/kubectx ~/.kubectx
fi

sudo ln -fs ~/.kubectx/kubectx /usr/local/bin/kubectx
sudo ln -fs ~/.kubectx/kubens /usr/local/bin/kubens

compdir=$(pkg-config --variable=completionsdir bash-completion)
sudo ln -sf ~/.kubectx/completion/kubens.bash "$compdir"/kubens
sudo ln -sf ~/.kubectx/completion/kubectx.bash "$compdir"/kubectx
cat << EOF >> ~/.bashrc

# kubectx and kubens
export PATH=~/.kubectx:\$PATH
EOF

# Install helm
# See: https://helm.sh/docs/intro/install/#from-script
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm -f get_helm.sh

# Install skaffold
# See: https://skaffold.dev/docs/install/#standalone-binary
curl -fsSL -o skaffold "https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-$(dpkg --print-architecture)" && \
sudo install skaffold /usr/local/bin/
rm -f skaffold

# Install awscli
# See: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
curl -fsSL -o "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
unzip -o awscliv2.zip
sudo ./aws/install --update
rm -rf awscliv2.zip aws

# Install saml2aws
# See: https://github.com/Versent/saml2aws#linux
version=$(curl -Ls https://api.github.com/repos/Versent/saml2aws/releases/latest | jq -r .tag_name | cut -d 'v' -f2)
wget -c "https://github.com/Versent/saml2aws/releases/download/v${version}/saml2aws_${version}_linux_amd64.tar.gz" -O - | tar -xzv -C ~/.local/bin
chmod u+x ~/.local/bin/saml2aws
hash -r
cat << EOF >> ~/.bashrc

# Include users private bin if it exists
if [ -d "\$HOME/.local/bin" ] ; then
    PATH="\$HOME/.local/bin:\$PATH"
fi
EOF

# Set up completions
# shellcheck disable=SC2016
echo 'eval "$(~/.local/bin/saml2aws --completion-script-bash)"' >> ~/.bashrc

USERNAME="$1"
PASSWORD="$2"

if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
  echo "Username or Password not provided; exiting."
  exit 0
fi

if [[ "$USERNAME" =~ ^(.+)@company.com$ ]]; then
  echo "Username is an email; converting"
  USERNAME="${BASH_REMATCH[1]}"
  exit 0
fi

saml2aws configure \
  --idp-provider ADFS \
  --mfa Auto \
  --username "$USERNAME@company.com" \
  --password "$PASSWORD" \
  --url "https://sso.company.com/adfs/ls/IDPInitiatedSignOn.aspx" \
  --skip-prompt

whichsaml2aws=$(which saml2aws)
echo "
[default]
region = us-west-2

[profile saml]
credential_process = $whichsaml2aws login --profile=saml --role=<role-arn> --credential-process --credentials-file=$HOME/.aws/saml-credentials --skip-prompt
region = us-west-2

[profile staging]
credential_process = $whichsaml2aws login --profile=staging --role=<role-arn> --credential-process --credentials-file=$HOME/.aws/saml-credentials --skip-prompt
region = us-west-2

[profile production]
credential_process = $whichsaml2aws login --profile=production --role=<role-arn> --credential-process --credentials-file=$HOME/.aws/saml-credentials --skip-prompt
region = us-west-2
" >> ~/.aws/config

# Login and update kubeconfig for each of TWIOs regions
saml2aws login --profile=staging --role=<role-arn> --skip-prompt --disable-keychain --username "$USERNAME@company.com" --password "$PASSWORD" --force
AWS_PROFILE=staging aws eks update-kubeconfig --name eks-staging --alias staging

saml2aws login --profile=production --role=<role-arn> --skip-prompt --disable-keychain --username "$USERNAME@company.com" --password "$PASSWORD" --force
AWS_PROFILE=production aws eks update-kubeconfig --name eks-production --alias production
