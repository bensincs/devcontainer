#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo -e "\n\e[34m╔══════════════════════════════════╗"
echo -e "║\e[32m             Terraform \e[34m           ║"
echo -e "║\e[33m            Plan Script  \e[34m         ║"
echo -e "╚══════════════════════════════════╝"
echo -e "\e[35m   v0.0.1    🚀  🚀  🚀\n"

source $SCRIPT_DIR/load-env.sh

echo -e "\n\e[34m»»» ✅ \e[96mChecking pre-reqs\e[0m..."
if [[ $# -lt 1 ]]; then
  echo -e "\e[31m»»» 💥 Pass plan name as parameter to this script e.g. $0 foo"
  exit 1
fi

set -euo pipefail

TFPLAN_NAME=${1}
echo -e "\n\e[34m»»» ✅ \e[96mRunning terraform plan with output $TFPLAN_NAME.tfplan \e[0m..."
terraform plan -input=false -out $TFPLAN_NAME.tfplan
