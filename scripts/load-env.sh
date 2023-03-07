#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $SCRIPT_DIR/common.sh
set -e

if [ -z "$ENVIRONMENT_NAME" ]; then
    export ENVIRONMENT_NAME="local"
fi

ENV_FILE="$SCRIPT_DIR/environments/$ENVIRONMENT_NAME.env"

if [ ! -f $ENV_FILE ]; then
  warn "$ENVIORNMENT_NAME.env file not found, I do hope those environment variables are set!"
else
  # Load environmental vars from .env file
  info "Loading environment variables for $ENVIRONMENT_NAME."
  cat $ENV_FILE |grep =|grep -v SECRET
  echo ""
  export $(egrep -v '^#' $ENV_FILE | xargs)
fi