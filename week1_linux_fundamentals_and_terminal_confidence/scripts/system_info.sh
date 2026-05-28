#!/bin/bash

set -euo pipefail

echo "===== System Information ======="
echo "USer: $(whoami)"
echo "Hostname: $(hostaname)"
echo "Date: $(date)"
echo "Uptime: $(uptime -p)"
echo ""
echo "===== Disk usage ====="
echo "1. Disk usage based on file system"
df -h
echo ""
echo "2. Disk usage of a particular file"
du -h /home/kailashbadu/Desktop/Learning/

echo ""
echo "Memory Usage"
free -h

echo ""
echo "=== Top p5 process by cpu usage"
ps aux --sort=-%cpu | head -6


