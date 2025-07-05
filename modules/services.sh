#!/usr/bin/bash

# Services Module

CONFIG_FILE="./config/services.conf"
STATUS_JSON=()

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "  Missing config file: $CONFIG_FILE"
    exit 1
fi

# === Terminal Mode Setup ===
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# === Main Loop ===
while read -r SERVICE || [[ -n "$SERVICE" ]]; do
    [[ -z "$SERVICE" || "$SERVICE" =~ ^# ]] && continue

    if systemctl is-active --quiet "$SERVICE"; then
        if [[ "$OUTPUT_MODE" == "json" ]]; then
            STATUS_JSON+=("{\"service\":\"$SERVICE\",\"status\":\"running\"}")
        else
            echo -e "${GREEN} $SERVICE is running${RESET}"
        fi
    else
        if [[ "$OUTPUT_MODE" == "json" ]]; then
            STATUS_JSON+=("{\"service\":\"$SERVICE\",\"status\":\"inactive\"}")
        else
            echo -e "${RED} $SERVICE is NOT running${RESET}"
        fi
    fi
done < "$CONFIG_FILE"

# === Output JSON if required ===
if [[ "$OUTPUT_MODE" == "json" ]]; then
    JOINED=$(IFS=,; echo "${STATUS_JSON[*]}")
    echo "{\"module\":\"services\",\"status\":\"ok\",\"services\":[$JOINED]}"
fi
