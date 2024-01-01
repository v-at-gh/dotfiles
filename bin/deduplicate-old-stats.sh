#!/usr/bin/env bash

OLD_STATS_FILE_PATHS="$(find /Users/v/data/dump.d -type f -name "*.stats.*.txt")"

for FILE_PATH in ${OLD_STATS_FILE_PATHS}; do
    OLD_FILE_PATH="${FILE_PATH}"
    NEW_FILE_PATH="$(echo "${FILE_PATH}" | sed "s:.stats.:.statistics.endpoints.:")"

    # Check if NEW_FILE_PATH exists
    if [ ! -e "${NEW_FILE_PATH}" ]; then
        # If NEW_FILE_PATH does not exist, rename the old file to the new one
        mv "${OLD_FILE_PATH}" "${NEW_FILE_PATH}"
        echo "Renamed ${OLD_FILE_PATH} to ${NEW_FILE_PATH}"
    else
        # If both files exist, compare their md5 sums
        OLD_MD5=$(md5 "${OLD_FILE_PATH}" | awk '{print $1}')
        NEW_MD5=$(md5 "${NEW_FILE_PATH}" | awk '{print $1}')

        # If md5 sums match, remove the old file
        if [ "${OLD_MD5}" == "${NEW_MD5}" ]; then
            rm "${OLD_FILE_PATH}"
            echo "Removed ${OLD_FILE_PATH} as it has the same content as ${NEW_FILE_PATH}"
        fi
    fi
done
