#!/bin/bash
set -e

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# Pretty banner
echo -e "\n\e[34m╔══════════════════════════════════╗"
echo -e "║\e[32m            VPN Gateway \e[34m          ║"
echo -e "║\e[33m        Deployment Script  \e[34m       ║"
echo -e "╚══════════════════════════════════╝"
echo -e "\e[35m   v0.0.1    🚀  🚀  🚀\n"


# Pull in environment variables
source ${DIR}/load-env.sh
pushd "$DIR/../.devinfrastructure/vpn" > /dev/null

# reset the current directory on exit using a trap so that the directory is reset even on error
function finish {
  popd > /dev/null
}
trap finish EXIT

# Initialise Terraform with the key
"${DIR}"/terraform-init.sh vpn

# Plan and apply
"${DIR}"/terraform-plan.sh vpn
"${DIR}"/terraform-apply.sh vpn