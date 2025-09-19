#!/bin/bash

# Script to check npm dependencies against a list of known compromised packages.
# Usage: ./check-npm-deps.sh <path_to_compromised_packages.txt>

set -eo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# --- Usage Function ---
usage() {
    echo "Usage: $0 <path_to_compromised_packages.txt>"
    echo
    echo "Checks the current project's npm dependencies against a list of known bad packages."
    echo "Must be run from within an npm project directory."
    exit 1
}

# --- Argument Validation ---
if [[ -z "$1" || "$1" == "--help" || "$1" == "-h" ]]; then
    usage
fi

COMPROMISED_LIST_FILE="$1"

if [[ ! -f "$COMPROMISED_LIST_FILE" ]]; then
    echo -e "${RED}Error: The file '$COMPROMISED_LIST_FILE' was not found.${NC}"
    exit 1
fi

# --- Main Logic ---
echo -e "${BLUE}🔍 Getting a list of all installed npm packages...${NC}"
NPM_LS_OUTPUT=$(npm ls --all 2>/dev/null || true)

if [[ -z "$NPM_LS_OUTPUT" ]]; then
    echo -e "${RED}Error: Failed to run 'npm ls'. Are you in a directory with a node_modules folder?${NC}"
    exit 1
fi

echo -e "${BLUE} cross-referencing with '${COMPROMISED_LIST_FILE}'...${NC}"
echo

found_count=0

# Read the compromised packages file line by line
while IFS= read -r line; do
    # Skip comments and empty lines
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line// }" ]] && continue

    # The file format is 'package-name:1.2.3'
    # The 'npm ls' format is 'package-name@1.2.3'
    # We need to convert the format for comparison.
    search_pattern="${line/:/@}"

    # Check if the package@version string exists in the npm ls output
    if echo "$NPM_LS_OUTPUT" | grep -q --fixed-strings "$search_pattern"; then
        echo -e "${RED}🚨 FOUND COMPROMISED PACKAGE: $line${NC}"
        ((found_count++))
    fi

done < "$COMPROMISED_LIST_FILE"

# --- Summary ---
echo
echo "----------------------------------------"
if [[ $found_count -gt 0 ]]; then
    echo -e "${RED}Scan Complete. Found $found_count compromised package(s) in your dependency tree.${NC}"
    exit 1 # Exit with an error code to signal that issues were found
else
    echo -e "${GREEN}✅ Scan Complete. No compromised packages from the list were found.${NC}"
fi