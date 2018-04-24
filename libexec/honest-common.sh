###
HONEST_VERSION="0.0.0"

# Color codes
if [[ -t 1 ]]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  NC='\033[0m' # No Color
fi

# -------- Basic functions --------
version() {
  echo "Honest version $HONEST_VERSION"
}

usage() {
  version
  sed -ne '/^#/!q;s/.\{1,2\}//;1,2d;p' < "$0"
}

die() {
  echo -e "[${RED}ERROR${NC}] $1"
  exit 1
}

info() {
  echo -e "[${GREEN}INFO${NC}] $1"
}

#######################################
# Check the format of package name. Exit on any failure.
# Globals:
#   None
# Arguments:
#   <Package> The package name with format '<vendor>:<package name>'
# Returns:
#   None
#######################################
check_package_format() {
  # Match the first : and extract vendor/pkg name
  vendor=${1%%:*}
  pkg=${1#*:}

  # Check format
  [[ "$1" != *":"* ]] && die "Vendor format error - missing separater ':'"
  ( [[ "$vendor" == "" ]] || [[ "$pkg" == "" ]] ) && die "Vendor format error"
  # Check supported vendors
  ! in_array "$vendor" "${VENDORS[@]}" && die "Vendor '$vendor' is currently not supported"
}

#######################################
# Check the if the element is in the array.
# Globals:
#   None
# Arguments:
#   <Element>
#   <Array> : e.g. "${array[@]}"
# Returns:
#   succeed:0 / failed:1
#######################################
in_array() {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}
