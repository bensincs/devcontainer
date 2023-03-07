#!/bin/bash
figlet VPN Client Create
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $SCRIPT_DIR/common.sh
source $SCRIPT_DIR/load-env.sh
set -e

pushd "$SCRIPT_DIR/../.devinfrastructure/vpn" > /dev/null

# reset the current directory on exit using a trap so that the directory is reset even on error
function finish {
  popd > /dev/null
}
trap finish EXIT

dns_forwarder_ip=$(terraform output dns_forwarder_ip | tr -d \")
info "Ensure VPN is connected (ping dns-forwarder:$dns_forwarder_ip)"
set +e # handling this error and want ping output to show to user
ping -w 20 -c 5 $dns_forwarder_ip # 5 pings for confidence, wait up to 10s overall
ping_result=$?
set -e
if [[ "$ping_result" == "0" ]]; then
    succ "ping successful"
else
    die "!!! ping failed to connect to dns-forwarder ($dns_forwarder_ip) - Your VPN client is probably not connected. Try 'make vpnclient'"
    exit 1
fi

info "Setting $dns_forwarder_ip as nameserver in /etc/resolv.conf"
if [[ $(grep -q "^nameserver $dns_forwarder_ip" /etc/resolv.conf; echo $?) == "0" ]]; then
    succ "$dns_forwarder_ip already set as nameserver in /etc/resolv.conf"
else
    # Keep a backup too for when you dns/gateway breaks!
    cp /etc/resolv.conf .resolv.bak

    # comment out existing nameserver in /etc/resolv.conf
    sed 's/^nameserver/#orig nameserver/g' /etc/resolv.conf  > tmpresolv.conf

    # Append the dns-forwarder IP as nameserver
    echo -e "\nnameserver $dns_forwarder_ip" >> tmpresolv.conf

    # Replace /etc/resolv.conf
    sudo bash -c "cat tmpresolv.conf > /etc/resolv.conf"
    rm tmpresolv.conf
    succ "Set $dns_forwarder_ip as nameserver in /etc/resolv.conf"
fi