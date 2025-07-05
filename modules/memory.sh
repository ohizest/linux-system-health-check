#!/usr/bin/bash

# Memory Usage Check Module

# Thresholds
WARNING_THRESHOLD=70
CRITICAL_THRESHOLD=90

# Colors
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# Get memory usage
MEM_TOTAL=$(free -m | awk '/^Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/^Mem:/ {print $3}')
MEM_USED_PERCENT=$(( MEM_USED * 100 / MEM_TOTAL ))

# Evaluate status
if [ "$MEM_USED_PERCENT" -ge "$CRITICAL_THRESHOLD" ]; then
    STATUS="${RED} High Memory Usage: ${MEM_USED_PERCENT}% of ${MEM_TOTAL}MB (Critical)${RESET}"
elif [ "$MEM_USED_PERCENT" -ge "$WARNING_THRESHOLD" ]; then
    STATUS="${YELLOW}  Memory Usage: ${MEM_USED_PERCENT}% of ${MEM_TOTAL}MB (Warning)${RESET}"
else
    STATUS="${GREEN} Memory Usage: ${MEM_USED_PERCENT}% of ${MEM_TOTAL}MB (OK)${RESET}"
fi

# Display memory status
echo -e "$STATUS"

# Show top 3 memory-consuming processes
echo -e "\n Top 3 Memory-Consuming Processes:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 4 | awk 'NR==1{print "PID  COMMAND        %MEM"} NR>1{printf "%-5s %-13s %s\n", $1, $2, $3}'
