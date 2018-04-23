#!/usr/bin/env bash
SCRIPT_DIR="$(readlink -f "$(dirname "$0")")"

# Stop at failure
set -e

function print_help() {
  echo "Usage:"
  echo "       $0 <PATH TO INSTALL>"
  echo ""
  echo "Example:"
  echo "       $0 /usr/local"
  echo ""
}

# Set prefix and exit if empty
PREFIX="$(readlink -f "$1")" || true
[[ "$PREFIX" == "" ]] && print_help && exit 1

# Create target directories
mkdir -p "$PREFIX"/{bin,libexec,share/honest}

# Install files with reserved relative symbolic link
cp -dr "$SCRIPT_DIR"/bin/* "$PREFIX"/bin
cp -dr "$SCRIPT_DIR"/libexec/* "$PREFIX"/libexec
cp -dr "$SCRIPT_DIR"/share/honest/* "$PREFIX"/share/honest

echo "Installed honest to '$PREFIX/bin/honest'"
