#!/usr/bin/env bash

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    >&2 echo "Error: This script should be sourced, not executed directly."
    >&2 echo "Usage: source ${BASH_SOURCE[0]}"
    exit 1
fi

parse_git_branch() {
    local branch
    branch=$(git branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        local status
        status=$(git status --porcelain 2>/dev/null)
        
        local new_files
        new_files=("$(echo "$status" | grep -c '^??')")

        local modified_files
        modified_files=("$(echo "$status" | grep -c '^ M\|^MM\|^M\|^RM')")
        
        local added_files
        added_files=("$(echo "$status" | grep -c '^A\|^AD')")
        
        local deleted_files
        deleted_files=("$(echo "$status" | grep -c '^ D\|^D')")

        local counters=""
        [ "${new_files[*]}" -gt 0 ] \
            && counters+="$(tput setaf 2)+${new_files[*]}$(tput sgr0)"
        [ "${modified_files[*]}" -gt 0 ] \
            && counters+="$(tput setaf 3)~${modified_files[*]}$(tput sgr0)"
        [ "${added_files[*]}" -gt 0 ] \
            && counters+="$(tput setaf 6)A${added_files[*]}$(tput sgr0)"
        [ "${deleted_files[*]}" -gt 0 ] \
            && counters+="$(tput setaf 1)-${deleted_files[*]}$(tput sgr0)"

        [ -n "$counters" ] && echo "$branch $(tput setaf 4)[$(tput sgr0)${counters}$(tput setaf 4)]$(tput sgr0)" || echo "$branch"
    fi
}

parse_python_venv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo " ($(basename "$VIRTUAL_ENV"))"
    fi
}

TIME="\[$(tput bold)\]\[$(tput setaf 6)\]\t"
EXPRESSION_IN_BRACKETS="\[$(tput setaf 2)\][\[$(tput setaf 3)\]\u\[$(tput setaf 1)\]@\[$(tput setaf 3)\]\h:\w\[$(tput setaf 6)\]\[$(tput setaf 2)\]]"
GIT_BRANCH="\[ \$(parse_git_branch) \]"
PYTHON_VENV="\[$(parse_python_venv)\]"
PROMPT="\[$(tput setaf 4)\]\n\\$\[$(tput sgr0)\] "
PS1="${TIME} ${EXPRESSION_IN_BRACKETS}${GIT_BRANCH}${PYTHON_VENV}${PROMPT}"