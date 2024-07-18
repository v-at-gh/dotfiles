#!/usr/bin/env bash

# Check if the script is sourced, not executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	>&2 echo "Error: This script should be sourced, not executed directly."
	>&2 echo "Usage: source ${BASH_SOURCE[0]}"
	exit 1
fi

# Configure command history settings
HISTCONTROL=ignoreboth:
HISTFILESIZE=16777216
HISTSIZE=16777216
HISTTIMEFORMAT="%a, %d %b %Y %T: "
PROMPT_COMMAND='history -a'

# Disable flow control (CTRL-S/CTRL-Q) for interactive sessions
# so that history search works forward and backward with (CTRL-R/CTRL-S)
[[ $- == *i* ]] && stty -ixon

# Add Homebrew binary directories to the PATH
add_to_path_if_exists() {
	if [ -d "$1" ]; then
		PATH="$1:$PATH"
	fi
}

add_to_path_if_exists "/opt/homebrew/bin"
add_to_path_if_exists "/opt/homebrew/sbin"
add_to_path_if_exists "$HOME/data/bin"
add_to_path_if_exists '/opt/homebrew/Cellar/awk/20230909/bin'

# Export the modified PATH
export PATH

# Source Bash completion script if available
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# Configure 'ltr' alias for listing files based on the operating system
if [[ "$(uname)" == "Darwin" ]]; then
	alias ltr='ls -ltrAGh'
elif [[ "$(uname)" == "Linux" ]]; then
	alias ltr='ls -ltrAh --color'
fi

# 'pxg' alias for process listing with grep
alias pxg='ps auxww | grep'
