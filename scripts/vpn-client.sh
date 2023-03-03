#!/bin/bash
set -e

figlet VPN Client

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

# Get VPN config
# -------------------------------------------------------------------------------------------------------
if [[ -f .vpn-config/openvpn.ovpn ]]; then
  echo "=== VPN config already exists (.vpn-config/openvpn.ovpn)"
else
  echo "=== Creating VPN config"

  # Get vars from TF State
  VPN_ID=$(terraform output vpn_id)
  VPN_CLIENT_CERT=$(terraform output client_cert)
  VPN_CLIENT_KEY=$(terraform output client_key)

  # Replace newlines with \n so sed doesn't break
  VPN_CLIENT_CERT="${VPN_CLIENT_CERT//$'\n'/\\n}"
  VPN_CLIENT_KEY="${VPN_CLIENT_KEY//$'\n'/\\n}"

  echo "Generating vpn client for VPN_ID: $VPN_ID"

  CONFIG_URL=$(az network vnet-gateway vpn-client generate --ids $VPN_ID -o tsv)
  curl -o "vpnconfig.zip" "$CONFIG_URL"
  # Ignore complaint about backslash in filepaths
  unzip -o "vpnconfig.zip" -d "./vpnconftemp"|| true
  OPENVPN_CONFIG_FILE="./vpnconftemp/OpenVPN/vpnconfig.ovpn"

  echo "Updating file $OPENVPN_CONFIG_FILE"

  sed -i "s~\$CLIENTCERTIFICATE~$VPN_CLIENT_CERT~" $OPENVPN_CONFIG_FILE
  sed -i "s~\$PRIVATEKEY~$VPN_CLIENT_KEY~g" $OPENVPN_CONFIG_FILE
  sed -i "s~log.*~log /var/log/openvpn.log~g" $OPENVPN_CONFIG_FILE

  mkdir -p .vpn-config
  cp $OPENVPN_CONFIG_FILE .vpn-config/openvpn.ovpn

  rm -r ./vpnconftemp
  rm vpnconfig.zip
fi

# Get VPN IP Address and Name
VPN_NAME=$(cat .vpn-config/openvpn.ovpn | grep "remote " | awk '{print $2}')
VPN_IP=$(terraform output vpn_ip)

if [[ -z $VPN_IP ]]; then
  echo "Require VPN_IP to be set. Maybe the Public IP address had not been allocated yet. Run 'make vpn' again to refresh the Terraform state."
  exit 1
fi

if [[ $(grep -q "$VPN_IP azuregateway" /etc/hosts; echo $?) == "0" ]]; then
  echo "=== VPN Gateway already in hosts file."
else
  # Remove any existing /etc/hosts entry for the VPN Gateway
  cat /etc/hosts | sed -r "s/([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) $VPN_NAME//g" > tmphosts

  # Add in the VPN Gateway host entry
  echo "$VPN_IP $VPN_NAME #vpngateway" >> tmphosts

  # Replace /etc/hosts
  sudo bash -c "cat tmphosts > /etc/hosts"
  rm tmphosts

  echo "== VPN Gateway '$VPN_NAME' added to hosts."
fi

#
# Restart OpenVPN
#
"${DIR}"/tunnel-create.sh
sudo cp .vpn-config/openvpn.ovpn /etc/openvpn/server.conf
sudo service openvpn restart