#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
    >&2 echo "Error: Invalid number of arguments. Please provide an IP address."
    exit 1
fi

#TODO: test if directory exists
DIR="$HOME/data/net/mtr"

validate_ipv4() {
    local address="$1"
    local IFS='.'
    local -a octets
    read -r -a octets <<< "$address"

    if [[ ${#octets[@]} -ne 4 ]]; then
        >&2 echo "Error: Invalid IPv4 address provided: $address"
        exit 2
    fi

    for octet in "${octets[@]}"; do
        if ! [[ $octet =~ ^[0-9]+$ ]] || ((octet < 0 || octet > 255)); then
            >&2 echo "Error: Invalid IPv4 address provided: $address"
            exit 2
        fi
    done
}

mtr-this() {
    local address="$1"
    validate_ipv4 "$address"
    /opt/homebrew/sbin/mtr --csv --no-dns "${address}" | tee "${DIR}/${address}.mtr.csv" | column -t -s,
}

mtr-this "$1"