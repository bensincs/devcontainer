#!/usr/bin/env bash
figlet Terraform Init
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $SCRIPT_DIR/common.sh
source $SCRIPT_DIR/load-env.sh
set -e

KEY=${1}

info "Checking pre-reqs..."
az > /dev/null 2>&1
if [ $? -ne 0 ]; then
  die "Azure CLI is not installed! 😥"
  exit
fi

terraform version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  die "Terraform is not installed! 😥"
  exit
fi

if [ -z "$KEY" ]; then
    die "No terrafrom state key was provided! 😥"
    exit
fi
succ "Pre-reqs checked."

info "Getting object id of current identity..."
OBJECT_ID=$(az account get-access-token --query "accessToken" -o tsv | jq -R -r 'split(".") | .[1] | @base64d | fromjson | .oid')
succ "Idenity $OBJECT_ID found."

info "Checking backend exists..."
if [ $(az storage account list --query "length([?resourceGroup=='$TF_BACKEND_RG' && name=='$TF_BACKEND_SA'])") -ne 1 ]; then
  warn "Backend does not exist... creating..."
	az deployment sub create \
	--location $LOCATION \
	--template-file $SCRIPT_DIR/../.devinfrastructure/tf-backend/tfstate.bicep \
	--parameters \
		stateResourceGroup=$TF_BACKEND_RG \
		stateStorageName=$TF_BACKEND_SA \
		stateContainerName=$TF_BACKEND_CONTAINER \
		dataContribPrincipalId=$OBJECT_ID \
  > /dev/null
	sleep 30s
  succ "Backend created."
else
  succ "Backend exists."
fi

info "Terraform init..."
terraform init -input=false -reconfigure -upgrade \
  -backend-config="resource_group_name=$TF_BACKEND_RG" \
  -backend-config="storage_account_name=$TF_BACKEND_SA" \
  -backend-config="container_name=$TF_BACKEND_CONTAINER" \
  -backend-config="use_azuread_auth=true" \
  -backend-config="key=$KEY"
succ "Terraform initilized."

info "Selecting workspace: $WORKSPACE..."
terraform workspace list | grep $WORKSPACE && \
	terraform workspace select $WORKSPACE || \
	terraform workspace new $WORKSPACE
succ "Workspace $WORKSPACE selected."