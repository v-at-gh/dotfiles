#!/usr/bin/env bash
# This file contains functions for collecting logs from iphone


# Check if the script is sourced, not executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    >&2 echo "Error: This script should be sourced, not executed directly."
    >&2 echo "Usage: source ${BASH_SOURCE[0]}"
    exit 1
fi

IPHONE_DATA_DIR="${HOME}/data/apple/iphone"

function prepare_iphone_for_capture {
    local FILE="${IPHONE_DATA_DIR}/strings/iphone-udid.txt"
    IPHONE_UDID=$(cat "$FILE")
	local udid="$IPHONE_UDID";
	rvictl -s "$udid";
}

function log_iphone_processes {
    local IPHONE_LOGS_DIR="${IPHONE_DATA_DIR}/log.d/archive"
    local DATE
    DATE="$(date +%F.%H-%M-%S)"
    if [ -z "$1" ]; then
        idevicesyslog --no-colors \
            | tee "${IPHONE_LOGS_DIR}/${DATE}.idevicesyslog.log"
    else
        local process="$1";
        idevicesyslog --no-colors --process "$process" \
            | tee "${IPHONE_LOGS_DIR}/${DATE}.idevicesyslog.${process}.log"
    fi;    
}
