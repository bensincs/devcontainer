#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

figlet Terraform Destroy

source $SCRIPT_DIR/load-env.sh

echo -e "\n\e[34m»»» ✅ \e[96mChecking pre-reqs\e[0m..."
if [[ $# -lt 1 ]]; then
  echo -e "\e[31m»»» 💥 Pass plan name as parameter to this script e.g. $0 foo"
  exit 1
fi

set -euo pipefail

TFPLAN_NAME=${1}

terraform destroy -auto-approve
