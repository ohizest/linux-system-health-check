#!/usr/bin/bash

# Disk Usage Check Module

# Thresholds
WARNING_THRESHOLD=80
CRITICAL_THRESHOLD=90

# Colors
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# Get disk usage for all mounted filesystems (excluding tmpfs and devtmpfs)
DISK_REPORT=$(df -h -x tmpfs -x devtmpfs --output=pcent,target | tail -n +2)

# Flag to track max usage for overall status
MAX_USAGE=0
OVERALL_STATUS=""

# Evaluate each mount point
while read -r line; do
    USAGE_PERCENT=$(echo "$line" | awk '{print $1}' | tr -d '%')
    MOUNT_POINT=$(echo "$line" | awk '{print $2}')

    # Track highest usage
    if [ "$USAGE_PERCENT" -gt "$MAX_USAGE" ]; then
        MAX_USAGE=$USAGE_PERCENT
    fi

    # Determine per-mount status
    if [ "$USAGE_PERCENT" -ge "$CRITICAL_THRESHOLD" ]; then
        COLOR=$RED
    elif [ "$USAGE_PERCENT" -ge "$WARNING_THRESHOLD" ]; then
        COLOR=$YELLOW
    else
        COLOR=$GREEN
    fi

    echo -e "${COLOR}${ICON} Disk at $MOUNT_POINT is ${USAGE_PERCENT}% full${RESET}"
done <<< "$DISK_REPORT"

# Summary status
if [ "$MAX_USAGE" -ge "$CRITICAL_THRESHOLD" ]; then
    OVERALL_STATUS="${RED} One or more disks critically full (${MAX_USAGE}%)${RESET}"
elif [ "$MAX_USAGE" -ge "$WARNING_THRESHOLD" ]; then
    OVERALL_STATUS="${YELLOW}  One or more disks approaching full (${MAX_USAGE}%)${RESET}"
else
    OVERALL_STATUS="${GREEN} All disks within safe usage levels${RESET}"
fi

echo -e "\n$OVERALL_STATUS"
