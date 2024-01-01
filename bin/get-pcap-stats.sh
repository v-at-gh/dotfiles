#!/usr/bin/env bash

TARGET_DIR="${HOME}/data/dump.d"

DUMP_FILES_PATHS="$(find "${TARGET_DIR}" -type f -name "*.pcapng" -exec stat -f "%m %N" {} \; | sort -n | cut -d\   -f2)"

get_dumpfile_endpoints_statistics() {
    local DUMP_FILE_PATH=$1
    local FAMILY=${2}
    local FAMILY=${FAMILY:="ipv4"}
    local DUMP_STATS_PATH="${DUMP_FILE_PATH%.pcapng}.statistics.endpoints.${FAMILY}.txt"
    # echo "Running: tshark -r $DUMP_FILE_PATH -q -z endpoints,${FAMILY} | tee ${DUMP_STATS_PATH}"
    # sleep 1
    # echo "Finished: tshark -r $DUMP_FILE_PATH -q -z endpoints,${FAMILY} | tee ${DUMP_STATS_PATH}"
    tshark -r "$DUMP_FILE_PATH" -q -z "endpoints,${FAMILY}" | tee "${DUMP_STATS_PATH}"
}

get_dumpfile_phs_statistics() {
    local DUMP_FILE_PATH=$1
    local DUMP_STATS_PATH="${DUMP_FILE_PATH%.pcapng}.statistics.io.phs.txt"
    # echo "Running: tshark -r $DUMP_FILE_PATH -q -z io,phs | tee ${DUMP_STATS_PATH}"
    # sleep 1
    # echo "Finished: tshark -r $DUMP_FILE_PATH -q -z io,phs | tee ${DUMP_STATS_PATH}"
    tshark -r "$DUMP_FILE_PATH" -q -z io,phs | tee "${DUMP_STATS_PATH}"
}

# # Process four files at a time
# batch_size=4
# count=0

for DUMP_FILE_PATH in ${DUMP_FILES_PATHS}; do
    get_dumpfile_phs_statistics "${DUMP_FILE_PATH}"
    for FAMILY in ipv4 ipv6; do
        get_dumpfile_endpoints_statistics "${DUMP_FILE_PATH}" "${FAMILY}"
    done

    # count=$((count + 1))
    # if [ $count -eq $batch_size ]; then
    #     wait
    #     count=0
    # fi
done
