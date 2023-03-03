#!/bin/bash
set -e

# Get the directory that this script is in so the script will work regardless
# of where the user calls it from. If the scripts or its targets are moved,
# these relative paths will need to be updated.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sudo service openvpn stop
# Replace /etc/resolv.conf
if [[ -f $DIR/../.devinfrastructure/vpn/.resolv.bak ]]; then
    sudo bash -c "cat $DIR/../.devinfrastructure/vpn/.resolv.bak > /etc/resolv.conf"
fi

rm -rf "${DIR}/../.devinfrastructure/vpn/.vpn-config/openvpn.ovpn"
