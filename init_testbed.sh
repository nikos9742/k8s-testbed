#!/bin/bash
#Init script (Install and configure provisionning tools)

set -e

command_exists () {
    command -v $1 >/dev/null 2>&1;
}

#kubectl
FILE=/usr/local/bin/kubectl
if [ -f "$FILE" ]; then
    echo "$FILE exist"
    echo "kubectl already present"
    kubectl version
else 
    echo "$FILE does not exist"
    echo "Installing kubectl"
    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
fi

#Linkerd
FILE2=$HOME/.linkerd2/bin/linkerd
if [ -f "$FILE" ]; then
    echo "$FILE2 exist"
    echo "linkerd already present"
    command_exists linkerd || export PATH=$PATH:$HOME/.linkerd2/bin
else 
    echo "$FILE2 does not exist"
    echo "Installing linkerd"
    curl -sL https://run.linkerd.io/install | sh
    export PATH=$PATH:$HOME/.linkerd2/bin
fi

#DOCTL
if ! command_exists doctl; then
    sudo snap install doctl
    sudo snap connect doctl:kube-config
    sudo snap connect doctl:ssh-keys :ssh-keys
fi

#HELM
if ! command_exists helm; then
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
fi
