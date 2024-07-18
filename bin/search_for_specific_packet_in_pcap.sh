#!/usr/bin/env bash

search_for_a_specific_packet() {
	local target="$1"
	local filter="$2"

	if [ ! -e "$target" ]; then
		echo "Error: Target '$target' does not exist."
		exit 1
	fi

	if [ ! -d "$target" ]; then
		echo "Error: Target '$target' is not a directory."
		exit 1
	fi

	for f in $(find "$target" -type f -name '*.pcapng' -o -name '*.pcap'); do
		if [ -f "$f" ] && file "$f" | grep -iq "pcapng" || file "$f" | grep -iq "pcap"; then
			if [ "$(tshark -r "$f" -Y "$filter" -a 'packets:1')" ]; then
				echo "$f"
			fi
		else
			echo "Skipping '$f': Not a valid pcap file."
		fi
	done
}

# Argument parsing
while [[ "$#" -gt 0 ]]; do
	case $1 in
		-t|--target)
			TARGET="$2"
			shift
			;;
		-f|--filter)
			FILTER="$2"
			shift
			;;
		*)
			echo "Unknown parameter: $1"
			exit 1
			;;
	esac
	shift
done

if [ -z "$TARGET" ]; then
	echo "Error: Target directory not provided. Use -t or --target option."
	exit 1
fi

if [ -z "$FILTER" ]; then
	echo "Error: Filter not provided. Use -f or --filter option."
	exit 1
fi

search_for_a_specific_packet "$TARGET" "$FILTER"
