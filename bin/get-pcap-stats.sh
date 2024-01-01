#!/usr/bin/env bash

TARGET_DIR="${HOME}/data/dump.d"

if [ "$(uname)" == "Darwin" ]; then
    FORMAT='-f "%m %N"'
elif [ "$(uname)" == "Linux" ]; then
    FORMAT='-c "%Y %n"'
fi

DUMP_FILES_PATHS="$(find "${TARGET_DIR}" -type f -name "*.pcapng" -exec stat "${FORMAT}" {} \; | sort -n | cut -d\   -f2)"

get_dumpfile_statistics() {
    local DUMP_FILE_PATH="$1"
    local TYPE="$2"
    local DUMP_STATS_PATH="${DUMP_FILE_PATH%.pcapng}.statistics.${TYPE/,/.}.txt"

    # Check if the file exists and is non-empty before overwriting
    if [ -s "${DUMP_STATS_PATH}" ]; then
        echo "File ${DUMP_STATS_PATH} already exists and is non-empty. Skipping."
    else
cat <<EOF
Executing:
tshark -r "${DUMP_FILE_PATH}" -q -z "${TYPE}" | tee "${DUMP_STATS_PATH}"
EOF

# Execution
tshark -r "${DUMP_FILE_PATH}" -q -z "${TYPE}" | tee "${DUMP_STATS_PATH}" && \

cat <<EOF
Statistics from file "${DUMP_FILE_PATH}" successfully collected to file "${DUMP_STATS_PATH}"

EOF
    fi
}

for DUMP_FILE_PATH in ${DUMP_FILES_PATHS}; do
    for FAMILY in 'io,phs' 'endpoints,ipv4' 'endpoints,ipv6'; do
        get_dumpfile_statistics "${DUMP_FILE_PATH}" "${FAMILY}"
    done
done
