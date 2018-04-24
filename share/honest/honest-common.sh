###
HONEST_VERSION="0.0.0"

# Currently supported package vendors
VENDORS=("gem")
REPO_VENDORS=("github" "bitbucket" "gitlab")
REPO_VENDORS_HOST=("github.com" "bitbucket.org" "gitlab.com")

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
  local vendor=${1%%:*}
  local pkg=${1#*:}

  # Check format
  [[ "$1" != *":"* ]] && die "Vendor format error - missing separater ':'"
  ( [[ "$vendor" == "" ]] || [[ "$pkg" == "" ]] ) && die "Vendor format error"
  # Check supported vendors
  ! in_array "$vendor" "${VENDORS[@]}" && die "Vendor '$vendor' is currently not supported"
}

#######################################
# Check the format of repo name. Exit on any failure.
# Globals:
#   None
# Arguments:
#   <Repo> The repo name with format '<vendor>:<author>/<project>[@..]'
# Returns:
#   None
#######################################
check_repo_format() {
  # Match the first : and extract vendor/pkg name
  local vendor_author=${1%%/*}
  local vendor=${vendor_author%%:*}
  local author=${vendor_author#*:}
  local proj=${1#*/}
  local tag=$([[ "$1" == *"@"* ]] && echo ${1##*@} || echo "")

  # Check format
  [[ "$1" == "https://"* ]] && return 0
  [[ "$1" != *":"*"/"* ]] && die "Repo format error - missing separater ':' or '/'"
  ( [[ "$vendor" == "" ]] || [[ "$author" == "" ]] || [[ "$proj" == "" ]] ) && die "Repo format error"
  # Check supported vendors
  ! in_array "$vendor" "${REPO_VENDORS[@]}" && die "Vendor of repo '$vendor' is currently not supported"
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

#######################################
# Find the index of the element in the array
# Globals:
#   None
# Arguments:
#   <Element>
#   <Array> : e.g. "${array[@]}"
# Returns:
#   None
#   Echos the index as string. Echo -1 if not found
#######################################
get_index() {
  local e match="$1"
  local index=0
  shift
  for e; do
      [[ "$e" == "$match" ]] && echo $index && return 0;
      index=$(( $index + 1 ))
  done
  echo "-1"
}

get_tmp_dir() {
  # The behavior is a little different betwen Linux and macOS, but it's okay.
  TMPDIR=$HONEST_TMPDIR mktemp -d -t $1
}
