#!/usr/bin/env bash

TARGET_DIR="${HOME}/data/dump.d"

DUMP_FILES_PATHS="$(find "${TARGET_DIR}" -type f -name "*.pcapng" -exec stat -f "%m %N" {} \; | sort -n | cut -d\   -f2)"

get_dumpfile_endpoints_statistics() {
    local DUMP_FILE_PATH=$1
    local FAMILY=${2}
    local FAMILY=${FAMILY:="ipv4"}
    local DUMP_STATS_PATH="${DUMP_FILE_PATH%.pcapng}.statistics.endpoints.${FAMILY}.txt"

    # Check if the file exists and is non-empty before overwriting
    if [ -s "${DUMP_STATS_PATH}" ]; then
        echo "File ${DUMP_STATS_PATH} already exists and is non-empty. Skipping."
    else
# Print info
cat <<EOF
Executing:
tshark -r "${DUMP_FILE_PATH}" -q -z "endpoints,${FAMILY}" | tee "${DUMP_STATS_PATH}"
EOF

# Execution
tshark -r "${DUMP_FILE_PATH}" -q -z "endpoints,${FAMILY}" | tee "${DUMP_STATS_PATH}" && \

# Print info
cat <<EOF
Statistics from file "${DUMP_FILE_PATH}" successfully collected to file "${DUMP_STATS_PATH}"

EOF
    fi
}

get_dumpfile_phs_statistics() {
    local DUMP_FILE_PATH=$1
    local DUMP_STATS_PATH="${DUMP_FILE_PATH%.pcapng}.statistics.io.phs.txt"

    # Check if the file exists and is non-empty before overwriting
    if [ -s "$DUMP_STATS_PATH" ]; then
        echo "File $DUMP_STATS_PATH already exists and is non-empty. Skipping."
    else
# Print info
cat <<EOF
Executing:
tshark -r "${DUMP_FILE_PATH}" -q -z io,phs | tee "${DUMP_STATS_PATH}"
EOF

# Execution
tshark -r "${DUMP_FILE_PATH}" -q -z io,phs | tee "${DUMP_STATS_PATH}" && \

# Print info
cat <<EOF
Statistics from file "${DUMP_FILE_PATH}" successfully collected to file "${DUMP_STATS_PATH}"

EOF
    fi
}

for DUMP_FILE_PATH in ${DUMP_FILES_PATHS}; do
    get_dumpfile_phs_statistics "${DUMP_FILE_PATH}"
    for FAMILY in ipv4 ipv6; do
        get_dumpfile_endpoints_statistics "${DUMP_FILE_PATH}" "${FAMILY}"
    done
done
