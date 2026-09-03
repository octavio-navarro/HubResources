#!/bin/bash

# Configuration
IP_LIST="lab_ips.txt"
LAB_PORT="4523"
SSH_USER="hub"   # Default user account set to 'hub'
KEY_FILE="~/.ssh/id_onh_hub"
VERBOSE=false

# Check for --verbose or -v flag passed as a command line argument
for arg in "$@"; do
    if [[ "$arg" == "-v" || "$arg" == "--verbose" ]]; then
        VERBOSE=true
        shift
    fi
done

# Check if IP list exists
if [ ! -f "$IP_LIST" ]; then
    echo "[!] Error: File '$IP_LIST' not found!"
    exit 1
fi

echo "=================================================="
echo "      Lab Remote Multi-Node Commander (v3)        "
echo "=================================================="
if [ "$VERBOSE" = true ]; then
    echo "  >>> VERBOSE MODE ENABLED <<<"
fi

# Prompt for the command to run
read -r -p "Enter the command to run on all PCs: " USER_CMD

if [ -z "$USER_CMD" ]; then
    echo "[!] No command provided. Exiting."
    exit 1
fi

# Ask if root/sudo access is needed
read -r -p "Does this command require sudo privileges? (y/N): " USE_SUDO

# Failsafe wrapper: 'set -e' halts local steps if a sub-command fails
REMOTE_RUNNER="set -e; $USER_CMD"

if [[ "$USE_SUDO" =~ ^[Yy]$ ]]; then
    read -r -s -p "Enter sudo password for $SSH_USER: " SUDO_PASS
    echo ""
    FINAL_CMD="echo '$SUDO_PASS' | sudo -S -E bash -c '$REMOTE_RUNNER'"
else
    FINAL_CMD="bash -c '$REMOTE_RUNNER'"
fi

echo ""
echo "=== Starting execution across active hosts ==="
echo "Target User:    $SSH_USER"
echo "Target Command: $USER_CMD"
echo "--------------------------------------------------"

success_count=0
fail_count=0
timeout_count=0

# Configure SSH Flags based on Verbose Mode
SSH_FLAGS=(
    -i "$KEY_FILE"
    -p "$LAB_PORT"
    -o "ConnectTimeout=4"
    -o "ServerAliveInterval=3"
    -o "ServerAliveCountMax=2"
    -o "StrictHostKeyChecking=accept-new"
    -o "BatchMode=no"
)

if [ "$VERBOSE" = true ]; then
    SSH_FLAGS+=("-vvv")
fi

# Read IP list using custom File Descriptor 3
while read -u 3 -r ip; do
    # Skip empty lines or comment lines
    [[ -z "$ip" || "$ip" =~ ^# ]] && continue

    echo "[$ip] Initiating connection as $SSH_USER..."

    if [ "$VERBOSE" = true ]; then
        # Verbose Mode: Directly stream output to terminal in real time
        ssh "${SSH_FLAGS[@]}" "$SSH_USER@$ip" "$FINAL_CMD"
        exit_code=$?
    else
        # Normal Mode: Capture output and print clean summary
        output=$(ssh "${SSH_FLAGS[@]}" "$SSH_USER@$ip" "$FINAL_CMD" 2>&1)
        exit_code=$?
    fi

    if [ $exit_code -eq 0 ]; then
        echo "[$ip] STATUS: SUCCESS!"
        if [ "$VERBOSE" = false ] && [ -n "$output" ]; then
            echo "$output" | sed 's/^/    /'
        fi
        ((success_count++))
    elif [ $exit_code -eq 255 ]; then
        echo "[$ip] STATUS: TIMEOUT / CONNECTION DROPPED! (Exit code 255)"
        if [ "$VERBOSE" = false ] && [ -n "$output" ]; then
            echo "$output" | sed 's/^/    [Debug] /'
        fi
        ((timeout_count++))
    else
        echo "[$ip] STATUS: FAILED! (Exit code: $exit_code)"
        if [ "$VERBOSE" = false ] && [ -n "$output" ]; then
            echo "$output" | sed 's/^/    [Error] /'
        fi
        ((fail_count++))
    fi
    echo "--------------------------------------------------"

done 3< "$IP_LIST"

echo "=== Summary ==="
echo "Total Successful: $success_count"
echo "Total Failed:     $fail_count"
echo "Total Timed Out:  $timeout_count"
