# script using case statement in bash

#!/bin/bash

set -euo pipefail

echo "Enter the action to nginx: "
echo "0. status"
echo "1. start"
echo "2. stop "
echo "3. enable "
echo "4. disable"

read -rp "Enter the action to nginx: " action

#if [[ $# -ne 1 ]]; then
 #       echo "USAGE: $0 <arg>"
  #      exit 1
#fi


#action=echo "$1" | tr '[:upper:]' ':lower:'
#aws_region=echo "$1" | tr '[:upper:]' '[:lower:]'
action="${action,,}"

echo "you choose $action"

case $action in
	status)
		echo "Checking status"
		sudo systemctl status nginx --no-pager
		echo "The status of nginx is checked"
		;;
	start)
		echo "Starting service...."
		sudo systemctl start nginx
		sudo systemctl status nginx --no-pager
		echo "Nginx has been started"
		;;
	stop)
		echo "Stopping nginx service..."
		sudo systemctl stop nginx
		echo "nginx has been stopped."
		;;
	enable)
		echo "Enabling the nginx service..."
		sudo systemctl enable nginx
		echo "Nginx enabled."
		;;
	disable)
		echo "Disabling the nginx service..."
		sudo systemctl disable nginx
		echo "Nginx disabled"
		;;
	*)
		echo "Not a valid actions"
		echo "Supported action are start, stop, enable and disable."
		exit 1
		;;
esac
	


