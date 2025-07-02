#!/usr/bin/bash

# LinuxSysGuard - Modular Linux Health Check Script

# === Config ===
MODULES_DIR="./modules" # Defines the directory where module scripts are stored (relative path "./modules").
OUTPUT_MODE="terminal"  # Options: terminal, json, log, html. Sets the default output format to "terminal" (other options are listed as comments).
ENABLED_MODULES=()      # Initializes an empty array to store which modules should be run.

# === Parse Arguments ===
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --cpu) ENABLED_MODULES+=("cpu");;
        --memory) ENABLED_MODULES+=("memory");;
        --disk) ENABLED_MODULES+=("disk");;
        --network) ENABLED_MODULES+=("network");;
        --services) ENABLED_MODULES+=("services");;
        --output) OUTPUT_MODE="$2"; shift;;
        --cron) CRON_MODE=true;;
        *) echo "Unknown parameter passed: $1"; exit 1;;
    esac
    shift
done

# === Run Checks ===
RESULTS=()

for MODULE in "${ENABLED_MODULES[@]}"; do
    MODULE_PATH="${MODULES_DIR}/${MODULE}.sh"
    if [[ -f "$MODULE_PATH" ]]; then
        OUTPUT=$("$MODULE_PATH")
        RESULTS+=("$OUTPUT")
    else
        echo "⚠️  Module '$MODULE' not found."
    fi
done

# === Display Results (Simple Terminal Output) ===
if [[ "$OUTPUT_MODE" == "terminal" ]]; then
    for RESULT in "${RESULTS[@]}"; do
        echo -e "$RESULT"
    done
else
    echo "Output mode '$OUTPUT_MODE' not implemented yet."
fi
