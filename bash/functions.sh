#!/usr/bin/env bash

# Check if the script is sourced, not executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	echo "Error: This script should be sourced, not executed directly." >&2;
	echo "Usage: source ${BASH_SOURCE[0]}" >&2;
	exit 1;
fi

function find_files_in_repo { 
	if [ -z "$1" ]; then DIR='.'; else DIR="$1"; fi;
	find "$DIR" -path ./.git -prune -o -type f 2>/dev/null \
		| grep -vw "^./.git$"
}
