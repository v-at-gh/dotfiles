#!/usr/bin/env bash
# A simple one-liner to summarize ip address range from stdin and returns a resulting list of networks.
#   Usage: summarize_ip_address_range.sh 188.114.96.0 - 188.114.100.100

echo "$@" | python3 -c '''from sys import stdin; from ipaddress import ip_address, summarize_address_range; range = [line for line in stdin if line != ""]; first, last = range[0].split("-"); print(", ".join([str(net) for net in summarize_address_range(ip_address(first.strip()), ip_address(last.strip()))]))'''