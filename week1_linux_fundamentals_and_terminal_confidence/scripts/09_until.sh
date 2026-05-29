#!/bin/bash

# Until loops are similar to while loops, but they execute until a specified condition becomes true.
# the condition is enclosed in square brackes [] and the loop ends with done

count=1
read -p "Enter a number: " num
until [[ $count -gt num ]]; do
	echo "Count is $count"
	((count++))
done

until ping -c 3 google.com ; do
	echo "Network not availabe"
	sleep 2
done
echo "Network is avaibale"

	
