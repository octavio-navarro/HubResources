#!/bin/bash

# Configuration
# Add as many subnets to this list as you need, separated by spaces
TARGET_SUBNETS=(
    "10.49.12.0/24"
    "10.49.61.0/24"
    "10.49.21.0/24"
    "10.49.34.0/24"
    "10.49.53.0/24"
)

LAB_PORT="4523"            # Your custom lab SSH port
SSH_USER="hub"             
TIMEOUT=2                  
OUTPUT_FILE="lab_ips.txt"

echo "=== Starting Multi-Subnet Lab Network Scan [$(date)] ==="
echo "# Lab Managed IPs - Generated $(date)" > "$OUTPUT_FILE"

# Track total found across all segments
total_found=0

# Loop through each subnet defined above
for subnet in "${TARGET_SUBNETS[@]}"; do
    echo "--------------------------------------------------"
    echo "Scanning segment: $subnet on Port $LAB_PORT..."
    
    # Scan the current subnet
    live_hosts=$(nmap -p "$LAB_PORT" --open -Pn "$subnet" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
    
    if [ -z "$live_hosts" ]; then
        echo "No active hosts found on $subnet."
        continue
    fi
    
    echo "Found active hosts in $subnet. Verifying SSH access..."
    
    # Verify SSH access for hosts in this specific subnet
    for ip in $live_hosts; do
        ssh -p "$LAB_PORT" \
            -o BatchMode=yes \
            -o ConnectTimeout=$TIMEOUT \
            -o StrictHostKeyChecking=accept-new \
            "$SSH_USER@$ip" "exit" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo "[SUCCESS] Connected to $ip"
            echo "$ip" >> "$OUTPUT_FILE"
            ((total_found++))
        else
            echo "[SKIPPED] $ip (Port open, but preauth/auth failed)"
        fi
    done
done

echo "=================================================="
echo "=== Scan Complete ==="
echo "All accessible IPs saved to: $OUTPUT_FILE"
echo "Total managed computers successfully mapped: $total_found"
