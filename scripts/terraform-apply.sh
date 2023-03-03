#!/usr/bin/env bash

echo -e "\n\e[34m╔══════════════════════════════════╗"
echo -e "║\e[32m            Terraform \e[34m        ║"
echo -e "║\e[33m          Apply Script  \e[34m       ║"
echo -e "╚══════════════════════════════════╝"
echo -e "\e[35m   v0.0.1    🚀  🚀  🚀\n"

set -euo pipefail

source ./load-env.sh

if [[ $# -lt 1 ]]; then
  echo -e "\e[31m»»» 💥 Pass plan name as parameter to this script e.g. $0 foo"
  exit 1
fi

TFPLAN_NAME=${1}

terraform apply -input=false -out ${TFPLAN_NAME}.tfplan
