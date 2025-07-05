#!/usr/bin/bash

# CPU Usage Check Module

# Thresholds
WARNING_THRESHOLD=70
CRITICAL_THRESHOLD=90

# Colors
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# Get average CPU usage (over 1 minute)
CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
CPU_LOAD_INT=${CPU_LOAD%.*}

# Evaluate status
if [ "$CPU_LOAD_INT" -ge "$CRITICAL_THRESHOLD" ]; then
    STATUS="${RED} High CPU Usage:${CPU_LOAD_INT}% (Critical)${RESET}"
elif [ "$CPU_LOAD_INT" -ge "$WARNING_THRESHOLD" ]; then
    STATUS="${YELLOW}  CPU Usage:${CPU_LOAD_INT}% (Warning)${RESET}"
else
    STATUS="${GREEN} CPU Usage:${CPU_LOAD_INT}% (OK)${RESET}"
fi

echo -e "$STATUS"
