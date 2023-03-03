#!/bin/bash
USERNAME=${1:-"vscode"}

echo "Installing azbrowse for user: $USERNAME"
OS=linux
ARCH=amd64
LATEST_VERSION=$(curl --silent "https://api.github.com/repos/lawrencegripper/azbrowse/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
echo $LATEST_VERSION
mkdir -p /home/$USERNAME/bin
wget https://github.com/lawrencegripper/azbrowse/releases/download/${LATEST_VERSION}/azbrowse_${OS}_${ARCH}.tar.gz
tar -C /home/$USERNAME/bin -zxvf azbrowse_${OS}_${ARCH}.tar.gz azbrowse
chmod +x /home/$USERNAME/bin/azbrowse
chown vscode /home/$USERNAME/bin/*