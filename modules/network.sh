#!/usr/bin/bash

# Network Check Module

# Colors
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# Target for ping test
TARGET="8.8.8.8"

# Check internet connectivity
ping -c 2 -W 2 $TARGET > /dev/null 2>&1
if [ $? -eq 0 ]; then
    CONNECTION_STATUS="${GREEN} Internet connectivity: Available${RESET}"
else
    CONNECTION_STATUS="${RED} Internet connectivity: Unavailable${RESET}"
fi

# Run ping test and extract latency + loss
PING_RESULT=$(ping -c 4 -q $TARGET 2>/dev/null)

if [[ $? -eq 0 ]]; then
    # Extract average latency
    AVG_LATENCY=$(echo "$PING_RESULT" | awk -F '/' '/rtt/ {print $5}')
    PACKET_LOSS=$(echo "$PING_RESULT" | awk -F ', ' '/packets transmitted/ {print $3}')

    if [[ $(echo "$AVG_LATENCY > 150" | bc -l) -eq 1 ]]; then
        LATENCY_STATUS="${YELLOW}  High latency: ${AVG_LATENCY} ms${RESET}"
    else
        LATENCY_STATUS="${GREEN} Latency: ${AVG_LATENCY} ms${RESET}"
    fi

    LOSS_STATUS="${GREEN} ${PACKET_LOSS}${RESET}"
else
    LATENCY_STATUS="${RED} Ping test failed${RESET}"
    LOSS_STATUS="${RED} Packet loss unknown${RESET}"
fi

# Show IP addresses of active interfaces
IP_SUMMARY=$(ip -brief addr | awk '$2 == "UP" {print $1 ": " $3}')

# Output summary
echo -e "$CONNECTION_STATUS"
echo -e "$LATENCY_STATUS"
echo -e "$LOSS_STATUS"
echo -e "\n Active Network Interfaces:"
echo -e "$IP_SUMMARY"
