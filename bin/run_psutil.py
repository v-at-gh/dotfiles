#!/usr/bin/env python3

import os, sys

try:
    import psutil
except ModuleNotFoundError:
    print(f'Module psutil not found.\n Install it with `pip3 install psutil`')
    sys.exit(1)

for i, pid in enumerate(sorted(set(connection.pid for connection in psutil.net_connections())), 1):
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
                f" {connection.laddr.ip}:{connection.laddr.port} {rsocket}"
                f" {connection.status}"
            )
        print(f"  Open files amount: {len(process_dict['open_files'])}")
        for open_file in process_dict['open_files']:
            print(f"    {open_file.fd} {open_file.path}")
        print()
    except psutil.NoSuchProcess:
        pass
