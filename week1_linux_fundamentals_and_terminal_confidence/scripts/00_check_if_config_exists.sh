#!/bin/bash

set -euo pipefail

if [[ -f /etc/nginx/nginx.conf ]]
then
  echo "Nginx config exixts"
else
  echo "No nginx config found"
fi
