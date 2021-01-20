#!/usr/bin/env bash
# This script converts an IPv4 iplist to CIDR block notation and JSON array format, sorting and de-duplicating IPs

# Set Variables
filename="iplist"
DEBUGMODE="0"


# Cleanup list
function cleanup {
	sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 $filename | uniq > iplist2
	mv iplist2 $filename
	# echo "iplist cleanup completed."
}

# Convert the list to CIDR notation if needed
function CIDR {

	# Remove existing file
	if [ -f CIDR-"$filename" ]; then
		rm CIDR-"$filename"
	fi
while read iplist
	do
		if [[ $DEBUGMODE = "1" ]]; then
			echo "IP: "$iplist
		fi

		# Test for CIDR notation
		if ! echo $iplist | egrep -q '^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([0-9]|[1-2][0-9]|3[0-2]))$'; then
			echo $iplist/32 >> CIDR-"$filename"
		else echo $iplist >> CIDR-"$filename"
		fi
	done < "$filename"
}
