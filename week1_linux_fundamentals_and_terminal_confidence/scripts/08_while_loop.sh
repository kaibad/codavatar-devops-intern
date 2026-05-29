#!/bin/bash

# while loop in bash

#counter
i=1
read -p "Enter a num: " num

while [[ i -le num  ]]; do
	echo "$i"
	#sleep 1s
	((i++))
done

# IFS in linux Internal field separator
#it is a special varibale that defines the character or characters use to separete a pattern into tokens for some operations. the default value of IFS is a space,tab, and newline character, which means that by default bash uses these characters to separate word in a string.

# bu default , IFS is set to a space, a tab, and a newline character, which allows bash to recognize these as word boundaries during word spliting.

# we can change IFS to any string we want, which gives use more flexibility in parsing fields within a string. for instance setting IFS to a colon : would allow us to parse fields separated bu colon, which is common in csv files.

# Ifs can also be use in th line parsing to control how fields in a string are separated.Commands like cur ccan utilize IFS as a delimeter to extract specific fields from a string.

echo "printing error line by line"
while IFS= read -r line
do
  if [[ "$line" == *ERROR* ]]
  then
    echo "Error founf:  $line"
  fi
done < pratice.log


