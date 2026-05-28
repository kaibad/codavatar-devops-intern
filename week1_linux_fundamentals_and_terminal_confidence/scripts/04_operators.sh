#!/bin/bash

# OPerators in bash
# The operators inbash are classified into different types
# 1. comparion/arithemetic comparison
# 2. string comparison
# 3. arithmetic
# 4. logical/boolean
# 5. file test

set -euo pipefail

# check if exactly 2 arg are passed or not
if [[ $# -ne 2 ]]; then
	echo "USAGE $0 <arg1> <arg2>"
fi

## Arithmetic Comparison

#check="$1 -ne $2"
#echo $check


echo "=======Arithemetic comparison========="
if [[ $1 -eq $2  ]]; then
	echo "$1 and $2 are samenumber"
else
	echo "$1 and $2 are diff number"

	if [[ $1 -lt $2 ]]; then
		echo "$2 is greater."
	else
		echo "$1 is greater"
	fi
fi

## Arithmetic
echo ""
echo "=======Arithneic operations======="
# There are two formats for arithmetic expansion: $[ expression ] 
# and $(( expression #)) its your choice which you use

sum=$[$1 + $2]
diff=$(($1-$2))
echo 3 x 2 = $((3 * 2))
echo 6 / 3 = $((6 / 3))
echo 8 % 7 = $((8 % 7))
echo 2 ^ 8 = $[ 2 ** 8 ]


echo "sum $sum"
echo "diff: $diff"

## string comparison

S1="Kailash"
S2="Badu"

if [ $S1 = $S2 ]; then
	echo "Both Strings are equal"
else
	echo "Strings are NOT equal"
fi


## file testing operators
# -e,-f,-d,-s

if [[ -f ../logs/pratice.logs ]];then
	echo "THis is regular file"
else
	echo "file not found"
fi






