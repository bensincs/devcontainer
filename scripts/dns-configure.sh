#!/bin/bash
set -e

# Pretty Banner
figlet DNS
# Get the directory that this script is in so the script will work regardless
# of where the user calls it from. If the scripts or its targets are moved,
# these relative paths will need to be updated.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# Pull in environment variables
source ${DIR}/load-env.sh

pushd "$DIR/../.devinfrastructure/vpn" > /dev/null

# reset the current directory on exit using a trap so that the directory is reset even on error
function finish {
  popd > /dev/null
}
trap finish EXIT

dns_forwarder_ip=$(terraform output dns_forwarder_ip | tr -d \")
echo "=== Ensure VPN is connected (ping dns-forwarder:$dns_forwarder_ip)"
set +e # handling this error and want ping output to show to user
ping -w 20 -c 5 $dns_forwarder_ip # 5 pings for confidence, wait up to 10s overall
ping_result=$?
set -e
if [[ "$ping_result" == "0" ]]; then
    echo "ping successful"
else
    echo "!!! ping failed to connect to dns-forwarder ($dns_forwarder_ip) - Your VPN client is probably not connected"
    echo "Try 'make vpnclient'"
    exit 1
fi

if [[ $(grep -q "^nameserver $dns_forwarder_ip" /etc/resolv.conf; echo $?) == "0" ]]; then
    echo "=== $dns_forwarder_ip already set as nameserver in /etc/resolv.conf"
else
    echo "=== Set $dns_forwarder_ip as nameserver in /etc/resolv.conf"

    # Keep a backup too for when you dns/gateway breaks!
    cp /etc/resolv.conf .resolv.bak

    # comment out existing nameserver in /etc/resolv.conf
    sed 's/^nameserver/#orig nameserver/g' /etc/resolv.conf  > tmpresolv.conf

    # Append the dns-forwarder IP as nameserver
    echo -e "\nnameserver $dns_forwarder_ip" >> tmpresolv.conf

    # Replace /etc/resolv.conf
    sudo bash -c "cat tmpresolv.conf > /etc/resolv.conf"
    rm tmpresolv.conf
fi