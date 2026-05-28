# in bash scripting there are three types of loops for, while and until loop
#!/bin/bash

# for loops
# For loops allow you to iterate over a list of items or a range of numbers. They are useful for repeating tasks a specific number of times.

# The for keyword is followed by a variable name, a range of values, and a do keyword, which marks the start of the loop block.

# for loop in range
for i in {1..5}; do
	echo "iteration: $i"
done

# sequenced loop
for i in $(seq 1 5 100); do
	echo "$i"
done

# c style for loop in bash

for (( i=0; i<10;i++  )); do
	echo "Counter: $i"
	#sleep 1
done

# loop through files

for file in ../logs/*.log*
do
	echo "processing $file"
done


# while loop
# #  digital clock using while loop

RED=$'\e[31m'
GREEN=$'\e[32m'
YELLOW=$'\e[33m'
NC=$'\e[0m'

#while true
#do
	#clear
#	echo $GREEN $(date +%T)
	#sleep 1s
#done


