#!/usr/bin/env python3

import sys
import os
import subprocess
import ipaddress
from datetime import datetime

DATA_DIRECTORY = os.path.expanduser("~/data/net/ipv4")

def validate_ipv4(address):
    try:
        ipaddress.IPv4Address(address)
    except ipaddress.AddressValueError:
        print(f"Error: Invalid IPv4 address provided: {address}")
        sys.exit(1)

def get_whois_report(address):
    try:
        output = subprocess.check_output(['whois', address], stderr=subprocess.STDOUT, text=True)
        return output
    except subprocess.CalledProcessError as e:
        print(f"Error: Failed to perform whois lookup for {address}.")
        print(f"Error message: {e.output}")
        sys.exit(1)

def save_whois_report(file_path, report):
    with open(file_path, 'w') as file:
        file.write(report)

def load_whois_report(file_path):
    with open(file_path, 'r') as file:
        return file.read()

def is_ip_within_range(ip_address, network_range: str):
    a, b = network_range.split(' - ')
    network_range = list(ipaddress.summarize_address_range(ipaddress.ip_address(a), ipaddress.ip_address(b)))[0]
    return ipaddress.IPv4Address(ip_address) in ipaddress.ip_network(network_range, strict=False)

def find_closest_match(ip_address):
    closest_match = None
    closest_match_range = None

    for root, dirs, files in os.walk(DATA_DIRECTORY):
        for file in files:
            if file.endswith(".whois.txt"):
                file_path = os.path.join(root, file)
                whois_report = load_whois_report(file_path)
                lines = whois_report.splitlines()

                inetnum = None
                for line in lines:
                    if line.lower().startswith("inetnum:") or line.lower().startswith("netrange:"):
                        inetnum = line.split(':', 1)[1].strip()
                        break

                if inetnum and is_ip_within_range(ip_address, inetnum):
                    return file_path

                if inetnum:
                    network_range = inetnum.split()[0]  # Extract the first IP/CIDR from inetnum
                    if not closest_match or ipaddress.IPv4Address(ip_address) in ipaddress.ip_network(network_range, strict=False):
                        closest_match = file_path
                        closest_match_range = network_range

    return closest_match, closest_match_range

def whoisthis(address):
    validate_ipv4(address)
    closest_match_file, closest_match_range = find_closest_match(address)
    
    if closest_match_file:
        whois_report = load_whois_report(closest_match_file)
        date_modified = os.path.getmtime(closest_match_file)
        formatted_date = datetime.fromtimestamp(date_modified).strftime('%Y-%m-%d %H:%M:%S')
        print_report(whois_report, address, closest_match_range, formatted_date)
    else:
        try:
            output = get_whois_report(address)
            file_path = os.path.join(DATA_DIRECTORY, f"{address}.whois.txt")
            save_whois_report(file_path, output)
            print_report(output, address, "", datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
        except subprocess.CalledProcessError as e:
            print(f"Error: Failed to perform whois lookup for {address}.")
            print(f"Error message: {e.output}")
            sys.exit(1)

def print_report(report, address, network_range, timestamp):
    print("-------- Report Start --------")
    print(report)
    print("-------- Report End --------")
    print(f"Whois report for IP address: {address}")
    if network_range:
        print(f"Network Range: {network_range}")
    print(f"Report requested on: {timestamp}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Error: Invalid number of arguments. Please provide an IP address.")
        sys.exit(1)
    
    ip_address = sys.argv[1]
    whoisthis(ip_address)
