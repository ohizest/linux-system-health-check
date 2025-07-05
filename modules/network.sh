#!/usr/bin/bash

# Network Module

PING_TARGET="8.8.8.8"
INTERFACES=$(ip -o link show | awk -F': ' '{print $2}' | tr '\n' ',' | sed 's/,$//')
PING_RESULT=$(ping -c 1 -W 1 $PING_TARGET 2>/dev/null)
PING_STATUS=$?
LATENCY=$(echo "$PING_RESULT" | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1)

# === Output for JSON mode ===
if [[ "$OUTPUT_MODE" == "json" ]]; then
    if [[ "$PING_STATUS" -eq 0 ]]; then
        STATUS="ok"
    else
        STATUS="fail"
    fi
    echo "{\"module\":\"network\",\"status\":\"$STATUS\",\"interfaces\":\"$INTERFACES\",\"ping_target\":\"$PING_TARGET\",\"latency_ms\":\"$LATENCY\"}"
    exit 0
fi

# === Output for Terminal mode ===
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

if [[ "$PING_STATUS" -eq 0 ]]; then
    echo -e "${GREEN} Network OK: ping $PING_TARGET = ${LATENCY} ms | Interfaces: ${INTERFACES}${RESET}"
else
    echo -e "${RED} Network FAIL: Cannot reach $PING_TARGET | Interfaces: ${INTERFACES}${RESET}"
fi