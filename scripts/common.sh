setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

info() {
  echo >&2 -e "${BLUE}INFO »»» ${1-}${NOFORMAT}"
}

err(){
  echo >&2 -e "${RED}ERROR 🚨 »»» ${1-}${NOFORMAT}"
}

succ(){
  echo >&2 -e "${GREEN}SUCCESS ✅ »»» ${1-}${NOFORMAT}"
}

warn(){
  echo >&2 -e "${YELLOW}WARNING ⚠️  »»» ${1-}${NOFORMAT}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  err "$msg"
  exit "$code"
}

# Run the common components
setup_colors