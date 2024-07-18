#!/usr/bin/env bash
# A simple one-liner to summarize ip address range from stdin and returns a resulting list of networks.
#   Usage: summarize_ip_address_range.sh 188.114.96.0 - 188.114.100.100

ONE_LINER='''from sys import stdin; from ipaddress import ip_address, summarize_address_range;'''
ONE_LINER+='''range = [line for line in stdin if line != ""];'''
ONE_LINER+='''first, last = range[0].split("-") if "-" in range[0] else range[0].split();'''
ONE_LINER+='''print(", ".join('''
ONE_LINER+='''[str(net) for net in summarize_address_range('''
ONE_LINER+='''ip_address(first.strip()), ip_address(last.strip())'''
ONE_LINER+=''')]'''
ONE_LINER+='''))'''

echo "$@" | python3 -c "$ONE_LINER"