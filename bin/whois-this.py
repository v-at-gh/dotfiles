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

def load_whois_report(file_path):
    with open(file_path, 'r') as file:
        return file.read()

def save_whois_report(file_path, report):
    with open(file_path, 'w') as file:
        file.write(report)

def print_report(report, address, timestamp):
    print("-------- Report Start --------")
    print(report)
    print("-------- Report End --------")
    print(f"Whois report for IP address: {address}")
    print(f"Report requested on: {timestamp}")

def whoisthis(address):
    validate_ipv4(address)
    file_path = os.path.join(DATA_DIRECTORY, f"{address}.whois.txt")
    
    if os.path.exists(file_path):
        whois_report = load_whois_report(file_path)
        date_modified = os.path.getmtime(file_path)
        formatted_date = datetime.fromtimestamp(date_modified).strftime('%Y-%m-%d %H:%M:%S')
        print_report(whois_report, address, formatted_date)
    else:
        try:
            output = get_whois_report(address)
            save_whois_report(file_path, output)
            print_report(output, address, datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
        except subprocess.CalledProcessError as e:
            print(f"Error: Failed to perform whois lookup for {address}.")
            print(f"Error message: {e.output}")
            sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Error: Invalid number of arguments. Please provide an IP address.")
        sys.exit(1)
    
    ip_address = sys.argv[1]
    whoisthis(ip_address)
