#!/usr/bin/env bash
figlet VPN Create
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $SCRIPT_DIR/common.sh
source $SCRIPT_DIR/load-env.sh
set -e

pushd "$SCRIPT_DIR/../.devinfrastructure/vpn" > /dev/null

# # reset the current directory on exit using a trap so that the directory is reset even on error
function finish {
  popd > /dev/null
}
# trap finish EXIT
# Initialise Terraform with the key
"$SCRIPT_DIR"/terraform-init.sh vpn

# Plan and apply
"$SCRIPT_DIR"/terraform-plan.sh vpn
"$SCRIPT_DIR"/terraform-apply.sh vpn