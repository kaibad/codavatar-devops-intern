# arrays allow us to store multiple values in a single variable, making data management easier.

# to create an array in Bash:
my_array=("value1" "value2" "value3")

# access elements using index (starts from 0)
echo ${my_array[0]}

# modifying array elements
my_array[1]="new_value"

# print the modified element
echo ${my_array[1]}

# print all elements
echo ${my_array[@]}
echo ${my_array[*]}
