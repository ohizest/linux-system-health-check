#!/usr/bin/bash

# Memory Usage Module

# Gather memory data
MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
MEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
MEM_USED=$((MEM_TOTAL - MEM_AVAILABLE))
USED_PERCENT=$((100 * MEM_USED / MEM_TOTAL))

# Get top memory-consuming process
TOP_PROC=$(ps -eo comm,%mem --sort=-%mem | awk 'NR==2 {print $1}')
TOP_MEM=$(ps -eo %mem --sort=-%mem | awk 'NR==2 {print $1}')

# === Output for JSON mode ===
if [[ "$OUTPUT_MODE" == "json" ]]; then
    echo "{\"module\":\"memory\",\"status\":\"ok\",\"used_percent\":$USED_PERCENT,\"top_process\":\"$TOP_PROC\",\"top_process_mem\":$TOP_MEM}"
    exit 0
fi

# === Output for Terminal mode ===
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

if (( USED_PERCENT < 70 )); then
    COLOR=$GREEN
elif (( USED_PERCENT < 90 )); then
    COLOR=$YELLOW
else
    COLOR=$RED
fi

echo -e "${COLOR} Memory Usage: ${USED_PERCENT}% | Top: $TOP_PROC (${TOP_MEM}%)${RESET}"
