#!/usr/bin/env bash

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	>&2 echo "Error: This script should be sourced, not executed directly."
	>&2 echo "Usage: source ${BASH_SOURCE[0]}"
	exit 1
fi

colorize() {
	local text="$1"
	local color="$2"
	echo "$(tput setaf ${color})${text}$(tput sgr0)"
}

parse_git_branch() {
	local branch
	branch=$(git branch --show-current 2>/dev/null)
	if [ -n "$branch" ]; then
		local status;
		status=$(git status --porcelain 2>/dev/null);
		local new_files;      new_files=$(     echo "$status" | grep -c '^??');
		local modified_files; modified_files=$(echo "$status" | grep -c '^ M\|^MM\|^M\|^RM');
		local added_files;    added_files=$(   echo "$status" | grep -c '^A\|^AD');
		local deleted_files;  deleted_files=$( echo "$status" | grep -c '^ D\|^D');
		local counters="";
		[ "$new_files" -gt 0 ]      && counters+="$(colorize +$new_files 2)";
		[ "$modified_files" -gt 0 ] && counters+="$(colorize ~$modified_files 3)";
		[ "$added_files" -gt 0 ]    && counters+="$(colorize A$added_files 6)";
		[ "$deleted_files" -gt 0 ]  && counters+="$(colorize -$deleted_files 1)";
		[ -n "$counters" ] && echo "$branch $(tput bold)$(colorize [ 6)${counters}$(tput bold)$(colorize ] 6)" || echo "$branch";
	fi
}

parse_python_venv() {
	if [ -n "$VIRTUAL_ENV" ]; then
		echo " ($(basename "$VIRTUAL_ENV"))"
	fi
}

print_exit_code() {
	CODE="$?"; if [[ "$CODE" != 0 ]]; then echo -ne " ($CODE)"; fi
}

TIME="$(tput bold)$(tput setaf 6)\t";
EXPRESSION_IN_BRACKETS="\[$(tput setaf 2)\][\[$(tput setaf 3)\]\u\[$(tput setaf 1)\]@\[$(tput setaf 3)\]\h:\w\[$(tput setaf 6)\]\[$(tput setaf 2)\]]";
GIT_BRANCH=" \$(parse_git_branch) ";
PYTHON_VENV="\[$(parse_python_venv)\]";
PROMPT="\[$(tput setaf 4)\]\n\\$\[$(tput sgr0)\] ";
EXIT_CODE="\$(print_exit_code)";
# EXIT_CODE="$(CODE=$?; if [[ "$CODE" != 0 ]]; then echo -ne "($CODE)"; fi)"

# construct resulting bash prompt
PS1="${TIME} ${EXPRESSION_IN_BRACKETS}${EXIT_CODE}${GIT_BRANCH}${PYTHON_VENV}${PROMPT}"
