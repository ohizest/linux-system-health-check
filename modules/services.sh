#!/usr/bin/bash

# Service Status Check Module

# Colors
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# List of services to check
SERVICES=("nginx" "mysql" "docker" "ssh")

echo -e " Checking critical services:\n"

# Check each service
for SERVICE in "${SERVICES[@]}"; do
    if systemctl list-units --type=service | grep -q "${SERVICE}.service"; then
        STATUS=$(systemctl is-active "$SERVICE")
        if [[ "$STATUS" == "active" ]]; then
            echo -e "${GREEN} $SERVICE is running${RESET}"
        elif [[ "$STATUS" == "inactive" ]]; then
            echo -e "${YELLOW} $SERVICE is installed but inactive${RESET}"
        else
            echo -e "${RED} $SERVICE status: $STATUS${RESET}"
        fi
    else
        echo -e "${RED} $SERVICE not installed or not found${RESET}"
    fi
done
