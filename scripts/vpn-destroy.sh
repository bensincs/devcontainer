#!/bin/bash

figlet VPN Cleanup

# Get the directory that this script is in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${DIR}/load-env.sh

pushd "$DIR/../.devinfrastructure/vpn" > /dev/null

# tf destroy has issues as the vpn connection we're using gets destroyed mid-way
# so use the CLI to kill the RG
az group delete -n $TF_VAR_network_resource_group_name
rm -rf .terraform/
rm -rf .vpn-config/
rm -rf terraform.tfstate.d/
rm -rf .resolv.bak
rm -rf caCert.der
rm -rf caCert.pem
rm -rf .sshDNSKey
rm -rf vpn-output.json
rm -rf vpn-plan

# Delete the remote state
"${DIR}"/terraform-init.sh vpn
terraform workspace select default
terraform workspace delete "${WORKSPACE}"