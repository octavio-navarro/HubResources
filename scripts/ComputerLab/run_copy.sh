#!/bin/bash

# Using a different file descriptor (3) ensures stdin stays open for your sudo password
while read -u 3 -r ip; do
    # Skip empty lines or lines starting with a comment character '#'
    [[ -z "$ip" || "$ip" =~ ^# ]] && continue

    echo "========================================="
    echo "Deploying to $ip..."
    echo "========================================="
    
    # Copy the script over
    scp -P 4523 copy_keys.sh hub@"$ip":/tmp/copy_keys.sh
    
    # Force a pseudo-terminal (-t) to allow remote sudo password prompts
    ssh -t -p 4523 hub@"$ip" "sudo bash /tmp/copy_keys.sh && rm /tmp/copy_keys.sh"

done 3< lab_ips.txt
