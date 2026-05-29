# Break and continue statements are used to control loop execution break exits the loop. while continue skips to the next iteration.

# These statements are typically used inside conditional blocks to alter the flow of the loop.

for i in {1..5}; do
  if [ $i -eq 3  ]; then
	  continue
  fi
  echo "NUmber:$i"
  if [ $i -eq 4 ]; then
	  break
  fi
done
 
