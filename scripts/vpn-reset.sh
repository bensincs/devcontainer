#!/bin/bash
figlet VPN Reset
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $SCRIPT_DIR/common.sh
source $SCRIPT_DIR/load-env.sh
set -e

info "Stopping open vpn service..."
sudo service openvpn stop
succ "Stopped open vpn service."
# Replace /etc/resolv.conf
if [[ -f $SCRIPT_DIR/../.devinfrastructure/vpn/.resolv.bak ]]; then
    info "Replacing .resolv.conf..."
    sudo bash -c "cat $SCRIPT_DIR/../.devinfrastructure/vpn/.resolv.bak > /etc/resolv.conf"
    succ "Replaced reolv.conf."
fi

info "Deleting openvpn config..."
rm -rf "$SCRIPT_DIR/../.devinfrastructure/vpn/.vpn-config/openvpn.ovpn"
succ "Deleted openvpn coonfig."
