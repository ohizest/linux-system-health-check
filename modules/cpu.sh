#!/usr/bin/bash

# CPU Usage Module

LOAD=$(uptime | awk -F 'load average:' '{ print $2 }' | cut -d',' -f1 | xargs)
USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
USAGE_INT=${USAGE%.*}

if [[ "$OUTPUT_MODE" == "json" ]]; then
    echo "{\"module\":\"cpu\",\"status\":\"ok\",\"load_avg\":$LOAD,\"cpu_percent\":$USAGE_INT}"
else
    COLOR=$(tput setaf 2)  # green
    RESET=$(tput sgr0)
    if (( USAGE_INT > 80 )); then COLOR=$(tput setaf 1); fi  # red
    echo -e "${COLOR} CPU Load: $LOAD | CPU Usage: ${USAGE_INT}%${RESET}"
fi