#!/bin/bash
figlet VPN Destroy
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $SCRIPT_DIR/common.sh
source $SCRIPT_DIR/load-env.sh
set -e

pushd "$SCRIPT_DIR/../.devinfrastructure/vpn" > /dev/null

# tf destroy has issues as the vpn connection we're using gets destroyed mid-way
# so use the CLI to kill the RG
info "Deleting $TF_VAR_vpn_resource_group_name..."
az group delete -n $TF_VAR_vpn_resource_group_name
succ "Deleted $TF_VAR_vpn_resource_group_name."
info "Clearing local vpn files..."
rm -rf .terraform/
rm -rf .vpn-config/
rm -rf terraform.tfstate.d/
rm -rf .resolv.bak
rm -rf caCert.der
rm -rf caCert.pem
rm -rf .sshDNSKey
rm -rf vpn-output.json
rm -rf vpn-plan
succ "local vpn files cleared"


# Delete the remote state
info "Deleting remote state..."
"$SCRIPT_DIR"/terraform-init.sh vpn
terraform workspace select default
terraform workspace delete "${WORKSPACE}"
succ "Remote state deleted."