#!/bin/bash

set -e
# e = exit on error
# u = treat undefined variable as error
# o pipefail = it tells the shell that if any command in the pipeline failes (command1 | command2 | command 3) , treat the whole pipeline as failed.

# so it is best practie to wrote these set -euo pipefail after shebanng in the bash script

# Variable= variable is bash are used to store the data. Variable can hold any type of data means they are untyped.

NAME="kAILASH BADU"
echo "$NAME"

#while printting the variable we use $ sign

#designation= "DevOps Intern"
#echo "$designation"

# the reason of showing error while the aobe peice of code runs is the ways of the variable assignment the space. there should not be any space between then assignement operator = ,variable name and the data

designation="DevOps INTERN"
echo "$designation"

# env variables
echo "My home is $HOME"
echo "My usernamr is $USER"
#echo " $PATH"

# we can check all path name with env commands
# local vs global variable: the local variables are are only available inside a local cope means they are only vaiabla to use inaide a block as function but the global variables can be use in whole scripts

# the most commi variales operations are concatenation and arithmetic.
# concatenation means combine the string or the variable
# arithmatic means performing calculation
#

# Example od concatenation
FirstName="Kailash"
LastName="Badu"

echo "$FirstName$LastName"

# Example of arithemtic

a=10
b=20

sum=$(($a + $b))
echo "$sum"


# CONSTANTS IN BASH SCRIPTINH
# for constans we use readonly or declare commands

readonly mylogfile="/home/kailashbadu/Desktop/Learning/codavatar-devops-intern/week1_linux_fundamentals_and_terminal_confidence/logs/practice.logs"
#echo "$mylogfile"

# lets try to change it
#mylogfile="/tmp/log"
#echo "$mylogfile"

# this throws anerror saying the mylogfile is the readonly variable

# SOME VARIABLE OPERATIONS

MOVIE="batman"

## lenght of the variable
echo "${#MOVIE}"

## first char uppercase

echo "${MOVIE^}"

## all uppercase

echo "${MOVIE^^}"

## all lowercase
echo "${MOVIE,,}"

