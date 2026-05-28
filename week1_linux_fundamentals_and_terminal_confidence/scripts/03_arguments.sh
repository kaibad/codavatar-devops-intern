#!/bin/bash

set -euo pipefail

# ARGUMENTS in bash 
# there are 10 positional arguments
# these positional arguments are the means to enter data in a bash prpgram when it is invoked from the command line

echo "the script name: $0"

echo "first argument is : $1"

echo "Second arg is : $2"

echo "Similarly this are upto 9"

# some special terms in arguments

echo "$@" # all arguments as separted words
echo "$*" # all argumenst as single word or string
echo  "the number os argumenst is $#" # number of arguments
echo "$?" # exit code od last command
echo "$_" # last argument of previuos comand
echo "$$" # current process id
