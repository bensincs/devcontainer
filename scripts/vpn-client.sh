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

# Get VPN config
# -------------------------------------------------------------------------------------------------------
info "Getting vpn config"
if [[ -f .vpn-config/openvpn.ovpn ]]; then
  succ "VPN config already exists (.vpn-config/openvpn.ovpn)"
else
  warn "VPN config does not exist. Creating..."

  # Get vars from TF State
  VPN_ID=$(terraform output vpn_id | tr -d \")
  VPN_CLIENT_CERT=$(terraform output -json client_cert | tr -d \")
  VPN_CLIENT_KEY=$(terraform output  -json client_key | tr -d \")

  info "Generating vpn client for VPN_ID: $VPN_ID"

  CONFIG_URL=$(az network vnet-gateway vpn-client generate --ids "$VPN_ID" -o tsv)
  curl -o "vpnconfig.zip" "$CONFIG_URL"
  # Ignore complaint about backslash in filepaths
  unzip -o "vpnconfig.zip" -d "./vpnconftemp"|| true
  OPENVPN_CONFIG_FILE="./vpnconftemp/OpenVPN/vpnconfig.ovpn"

  info "Updating file $OPENVPN_CONFIG_FILE"

  sed -i "s~\$CLIENTCERTIFICATE~$VPN_CLIENT_CERT~" $OPENVPN_CONFIG_FILE
  sed -i "s~\$PRIVATEKEY~$VPN_CLIENT_KEY~g" $OPENVPN_CONFIG_FILE
  sed -i "s~log.*~log /var/log/openvpn.log~g" $OPENVPN_CONFIG_FILE

  mkdir -p .vpn-config
  cp $OPENVPN_CONFIG_FILE .vpn-config/openvpn.ovpn

  rm -r ./vpnconftemp
  rm vpnconfig.zip

  succ "VPN config created."
fi

# Get VPN IP Address and Name
VPN_NAME=$(cat .vpn-config/openvpn.ovpn | grep "remote " | awk '{print $2}')
VPN_IP=$(terraform output vpn_ip)

if [[ -z $VPN_IP ]]; then
  die "Require VPN_IP to be set. Maybe the Public IP address had not been allocated yet. Run 'make vpn' again to refresh the Terraform state."
  exit 1
fi

if [[ $(grep -q "$VPN_IP azuregateway" /etc/hosts; echo $?) == "0" ]]; then
  warn "VPN Gateway already in hosts file."
else
  info "Removing existing hosts for vpn gateway..."
  # Remove any existing /etc/hosts entry for the VPN Gateway
  cat /etc/hosts | sed -r "s/([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) $VPN_NAME//g" > tmphosts
  succ "Hosts cleared."
  info "Adding VPN Gateway host entry..."
  # Add in the VPN Gateway host entry
  echo "$VPN_IP $VPN_NAME #vpngateway" >> tmphosts

  # Replace /etc/hosts
  sudo bash -c "cat tmphosts > /etc/hosts"
  rm tmphosts
  succ "VPN Gateway '$VPN_NAME' added to hosts."
fi

#
# Restart OpenVPN
#
info "Restarting OpenVPN..."
"$SCRIPT_DIR"/tunnel-create.sh
sudo cp .vpn-config/openvpn.ovpn /etc/openvpn/server.conf
sudo service openvpn restart
succ "OpenVPN restarted."