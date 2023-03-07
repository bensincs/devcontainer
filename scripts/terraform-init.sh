#!/usr/bin/env bash
KEY=${1}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

figlet Terraform Init

echo -e "\n\e[34m»»» ✅ \e[96mChecking pre-reqs\e[0m..."
az > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo -e "\e[31m»»» ⚠️  Azure CLI is not installed! 😥"
  exit
fi

terraform version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo -e "\e[31m»»» ⚠️  Terraform is not installed! 😥"
  exit
fi

if [ -z "$KEY" ]; then
    echo -e "\e[31m»»» ⚠️  No terrafrom state key was provided! 😥"
    exit
fi

source $SCRIPT_DIR/load-env.sh

echo -e "\n\e[34m»»» ✅ \e[96mGetting object id of current identity \e[0m..."
OBJECT_ID=$(az account get-access-token --query "accessToken" -o tsv | jq -R -r 'split(".") | .[1] | @base64d | fromjson | .oid')

echo -e "\n\e[34m»»» ✅ \e[96mChecking backend exists\e[0m..."
if [ $(az storage account list --query "length([?resourceGroup=='$TF_BACKEND_RG' && name=='$TF_BACKEND_SA'])") -ne 1 ]; then
    echo -e "\n\e[34m»»» ✅ \e[96mCreating backend\e[0m..."
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
fi

echo -e "\n\e[34m»»» ✨ \e[96mTerraform init\e[0m..."
terraform init -input=false -reconfigure \
  -backend-config="resource_group_name=$TF_BACKEND_RG" \
  -backend-config="storage_account_name=$TF_BACKEND_SA" \
  -backend-config="container_name=$TF_BACKEND_CONTAINER" \
  -backend-config="use_azuread_auth=true" \
  -backend-config="key=$KEY"

terraform workspace list | grep $WORKSPACE && \
	terraform workspace select $WORKSPACE || \
	terraform workspace new $WORKSPACE