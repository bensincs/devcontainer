#!/usr/bin/env bash
figlet Terraform Destroy
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $SCRIPT_DIR/common.sh
source $SCRIPT_DIR/load-env.sh
set -e

info "Running terraform destory"
terraform destroy -auto-approve
succ "Terraform destroyed successfully"