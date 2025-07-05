#!/usr/bin/bash

# Disk Usage Module

# Check root partition usage
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
DISK_AVAIL=$(df -h / | awk 'NR==2 {print $4}')
MOUNT_POINT=$(df -h / | awk 'NR==2 {print $6}')

# === Output for JSON mode ===
if [[ "$OUTPUT_MODE" == "json" ]]; then
    echo "{\"module\":\"disk\",\"status\":\"ok\",\"used_percent\":$DISK_USAGE,\"available\":\"$DISK_AVAIL\",\"mount_point\":\"$MOUNT_POINT\"}"
    exit 0
fi

# === Output for Terminal mode ===
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

if (( DISK_USAGE < 70 )); then
    COLOR=$GREEN
elif (( DISK_USAGE < 90 )); then
    COLOR=$YELLOW
else
    COLOR=$RED
fi

echo -e "${COLOR} Disk Usage on $MOUNT_POINT: ${DISK_USAGE}% used, $DISK_AVAIL free${RESET}"
