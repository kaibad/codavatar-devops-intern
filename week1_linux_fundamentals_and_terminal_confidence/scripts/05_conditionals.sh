#!/bin/bash

set -euo pipefail

# If statements allow us to execute code based on a condition. If the condition is true, the code block will run.
# If...else statements provide a way to execute one block of code if a condition is true and another block if it is false.
# Elif statements allow you to check multiple conditions in sequence. If the first condition is false, the next one is checked.
# Nested if statements allow us to place an if statement inside another if statement, enabling more complex logic.


num=5
if [ $num -gt 0 ]; then
  if [ $num -lt 10 ]; then
    echo "Number is between 1 and 9"
  fi
fi
