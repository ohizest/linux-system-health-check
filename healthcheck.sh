#!/usr/bin/bash

# SysGuard - Modular Linux Health Checker
# Phase 2: Add support for --output log

MODULES_DIR="./modules"
OUTPUT_MODE="terminal"
LOG_FILE="./sysguard.log"
ENABLED_MODULES=()

# === Parse CLI Arguments ===
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --cpu|--memory|--disk|--network|--services)
            ENABLED_MODULES+=("${1/--/}")
            ;;
        --output)
            OUTPUT_MODE="$2"
            shift
            ;;
        *)
            echo "❌ Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

# If no modules provided, run all
if [[ ${#ENABLED_MODULES[@]} -eq 0 ]]; then
    ENABLED_MODULES=("cpu" "memory" "disk" "network" "services")
fi

# === Run Each Module ===
RESULTS=()
for MODULE in "${ENABLED_MODULES[@]}"; do
    MODULE_PATH="${MODULES_DIR}/${MODULE}.sh"
    if [[ -f "$MODULE_PATH" ]]; then
        export OUTPUT_MODE  # Pass to modules
        OUTPUT=$("$MODULE_PATH")
        RESULTS+=("$OUTPUT")
    else
        echo "⚠️  Module '$MODULE' not found"
    fi
done

# === Output Handling ===
case "$OUTPUT_MODE" in
    terminal)
        for RESULT in "${RESULTS[@]}"; do
            echo -e "$RESULT"
        done
        ;;
    log)
        {
            echo "=============================="
            echo "SysGuard Report - $(date)"
            echo "=============================="
            for RESULT in "${RESULTS[@]}"; do
                # Strip ANSI color codes before logging
                echo -e "$RESULT" | sed 's/\x1B\[[0-9;]*[mK]//g'
            done
            echo ""
        } >> "$LOG_FILE"
        echo " Log saved to $LOG_FILE"
        ;;
    *)
        echo "Unsupported output mode: $OUTPUT_MODE"
        ;;
esac