#!/usr/bin/env bash
figlet Terraform Apply
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $SCRIPT_DIR/common.sh
source $SCRIPT_DIR/load-env.sh
set -e

info "Checking pre-reqs..."
if [[ $# -lt 1 ]]; then
  die "Pass plan name as parameter to this script e.g. $0 foo"
  exit 1
fi
succ "Pre-reqs checked."
TFPLAN_NAME=${1}

info "Running terraform apply with plan output $TFPLAN_NAME.tfplan"
terraform apply -input=false ${TFPLAN_NAME}.tfplan
succ "Terraform applied successfully"
