#!/usr/bin/env bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
	echo "Usage: $0 <remove/print> <N> <filename>"
	exit 1
fi

operation=$1
N=$2
filename=$3

if [ "$operation" == "remove" ]; then
	# Remove the first N characters from every line in the file
	awk '{print substr($0,'"$N"+1')}' "$filename" > "${filename}.temp"
	mv "${filename}.temp" "$filename"
	echo "Removed first $N characters from every line in $filename"
elif [ "$operation" == "print" ]; then
	# Print the first N characters from every line in the file
	awk '{print substr($0,1,'"$N"')}' "$filename"
else
	echo "Invalid operation. Use 'remove' or 'print'."
	exit 1
fi
