#!/bin/bash
USERNAME=${1:-"vscode"}

apt-get update
apt-get -y install --no-install-recommends apt-utils apt-transport-https nano zip unzip curl icu-devtools make openvpn dnsutils figlet bsdmainutils jq