#!/usr/bin/env python3

import sys

# Check if the correct number of arguments is provided
if len(sys.argv) != 4:
    print("Usage: {} <remove/print> <N> <filename>".format(sys.argv[0]))
    sys.exit(1)

operation = sys.argv[1]
N = int(sys.argv[2])
filename = sys.argv[3]

with open(filename, 'r') as file:
    lines = file.readlines()

if operation == "remove":
    # Remove the first N characters from every line in the content
    modified_lines = [line[N:] for line in lines]
    with open(filename, 'w') as file:
        file.writelines(modified_lines)
    print("Removed first {} characters from every line in {}".format(N, filename))
elif operation == "print":
    # Print the first N characters from every line in the content
    for line in lines:
        print(line[N:], end="")
else:
    print("Invalid operation. Use 'remove' or 'print'.")
    sys.exit(1)
