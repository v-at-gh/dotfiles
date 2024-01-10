#!/usr/bin/env python3

import sys, os

from os import geteuid
from sys import exit, platform

try:
    import psutil
except ModuleNotFoundError:
    print(f'Module psutil not found.\nInstall it with `pip3 install psutil`')
    exit(1)

def check_root_permissions():
    return platform == 'darwin' and geteuid() != 0

if check_root_permissions():
    print('Under macOS, you need to run this version as root. Exiting.')
    exit(2)

def print_processes_with_their_corresponding_connections_and_open_files_as_a_nested_list():
    connections = psutil.net_connections()
    sorted_pids_of_processes_with_connections = sorted(set(connection.pid for connection in connections if connection.pid != None))
    for i, pid in enumerate(sorted_pids_of_processes_with_connections, 1):
        try:
            process_dict = psutil.Process(pid).as_dict()
            print(f"{i}. {(process_dict['exe'])}")
            print(f"  Connections amount: {len(process_dict['connections'])}")
            for connection in process_dict['connections']:
                if connection.raddr != ():
                    rsocket = f" {connection.raddr.ip}:{connection.raddr.port}"
                else:
                    rsocket = ''
                print(
                    f"    {'IPv4' if connection.family == 2 else 'IPv6'}"
                    f" {'TCP' if connection.type == 1 else 'UDP'}"
                    f" {connection.laddr.ip}:{connection.laddr.port}{rsocket}"
                    f" {connection.status}"
                )
            print(f"  Open files amount: {len(process_dict['open_files'])}")
            for open_file in process_dict['open_files']:
                print(f"    {open_file.fd} {open_file.path}")
            print()
        except psutil.NoSuchProcess:
            pass

def main():
    print_processes_with_their_corresponding_connections_and_open_files_as_a_nested_list()

if __name__ == '__main__':
    main()