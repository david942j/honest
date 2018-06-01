###
HONEST_VERSION="1.0.0"

# Currently supported package vendors
SUPPORTED_VENDORS=(gem pip)

# Set log level to 1 if not set. The number can be 0(any) - 5,
# representing - debug, info, warn, error, and fatal
HONEST_LOGGING_LEVEL=${HONEST_LOGGING_LEVEL:-1}
LOG_LEVEL_DEBUG=0
LOG_LEVEL_INFO=1
LOG_LEVEL_WARN=2
LOG_LEVEL_ERROR=3
LOG_LEVEL_FATAL=4

# Color codes
if [[ -t 1 ]]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  GRAY='\033[0;37m'
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
  error "$1" && exit 1
}

debug() {
  local level=$HONEST_LOGGING_LEVEL
  [[ $level -le $LOG_LEVEL_DEBUG ]] && echo -e "[${GRAY}DEBUG${NC}] $1" >&2
}

info() {
  local level=$HONEST_LOGGING_LEVEL
  [[ $level -le $LOG_LEVEL_INFO ]] && echo -e "[${GREEN}INFO${NC}] $1" >&2
}

warn() {
  local level=$HONEST_LOGGING_LEVEL
  [[ $level -le $LOG_LEVEL_WARN ]] && echo -e "[${YELLOW}WARN${NC}] $1" >&2
}

error() {
  local level=$HONEST_LOGGING_LEVEL
  [[ $level -le $LOG_LEVEL_ERROR ]] && echo -e "[${RED}ERROR${NC}] $1" >&2
}

fatal() {
  local level=$HONEST_LOGGING_LEVEL
  [[ $level -le $LOG_LEVEL_FATAL ]] && echo -e "[${RED}FATAL${NC}] $1" >&2
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
  ! in_array "$vendor" "${SUPPORTED_VENDORS[@]}" && die "Vendor '$vendor' is currently not supported"
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

remove_prefix() {
  echo "$1" | sed -e "s/^$2//"
}

#######################################
# Check whether the command exist in a safe way
# Globals:
#   None
# Arguments:
#   <command>
# Returns:
#   0: found, 1: NOT found
#######################################
command_exist() {
  command_found=$(command -v "$1" 2> /dev/null)
  if [[ "$command_found" == "" ]]; then
    return 1 # NOT found
  else
    return 0 # Found
  fi
}

#######################################
# Check command's existence and show
# proper message, then exit.
# Globals:
#   None
# Arguments:
#   <command>
# Returns:
#   None
#######################################
command_or_die() {
  ! command_exist "$1" && die "Command '$1' is not installed on your system"
}

#######################################
# The common option parser for libexec/honest-$vendor
# Globals:
#   package, package_ver, path
# Arguments:
#   <package> <destination> [-v <version>]
# Returns:
#   None
#######################################
vendor_option_parser() {
  # Parse arguments
  while [[ "$1" != "" ]]; do
    case "$1" in
      -h|--help )
        usage
        exit 0
        ;;
      --version)
        version
        exit 0
        ;;
      -v)
        package_ver="$2"
        shift 2
        ;;
      * )
        # Exit on argument starting with hyphen "-"
        [[ "$1" == "-"* ]] && die "Unknown argument $1"
        # Remember the string type arguments in the array
        args+=("$1")
        shift
        ;;
    esac
  done

  # Check # of input arguments after parsing the input arguments
  [[ ${#args[@]} == 0 ]] && usage && exit 0
  [[ ${#args[@]} < 2 ]] && die "Both <package> and <destination> are required!"

  # Check the format and exit on any failure
  check_package_format "${args[0]}"

  package="${args[0]#*:}"
  path="${args[1]}"
}
