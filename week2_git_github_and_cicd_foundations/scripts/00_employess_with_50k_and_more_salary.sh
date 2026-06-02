# Script to print the data of employess whose salary >=50k
#!/bin/bash

set -euo pipefail

# syntax
# awk options 'pattern {action}' filename
# diff terms used in awk
# NR: no. of record or row
# NF: no. of field
# $0: print everything
# $1,$2: field no.

#awk -F, '$NF>=50000 {print $0}' employee.csv
#awk -F, '$NF>=50000 {print $2 $3 $6}' employee.csv

#awk -F, '$NF>=50000 {print $2, $3, $6}' employee.csv

#awk -F, '$NF>=50000 {print $2 "\t" $3 "\t" $6}' employee.csv

awk -F, 'BEGIN{OFS=" | "} $NF>=50000 {print $2, $3, $6}' employee.csv

