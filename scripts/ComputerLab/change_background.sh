#!/bin/bash

# Configuration
LOCAL_IMAGE="/home/balmung/Pictures/hacked.jpg"  # PATH ON YOUR CONTROL MACHINE
REMOTE_DEST="/home/student/Pictures/wallpaper.jpg"   # Path where it will land on the lab PCs
LAB_PORT="4523"                                      # Your custom SSH port
IP_LIST="lab_ips.txt"

# Check if the local image actually exists before starting
if [ ! -f "$LOCAL_IMAGE" ]; then
    echo "Error: Local image '$LOCAL_IMAGE' not found!"
    exit 1
fi

echo "=== Starting Bulk Wallpaper Update ==="

# Read the IP list using File Descriptor 3 to prevent stream conflicts
while read -u 3 -r ip; do
    # Skip empty lines or lines starting with '#'
    [[ -z "$ip" || "$ip" =~ ^# ]] && continue

    echo "----------------------------------------"
    echo "Targeting: $ip"
    echo "----------------------------------------"

    # 1. Push the image to the student's Pictures folder on the remote machine
    echo "Sending wallpaper image..."
    scp -P "$LAB_PORT" -i ~/.ssh/id_onh_hub  "$LOCAL_IMAGE" "student@$ip:$REMOTE_DEST" 2>/dev/null

    if [ $? -ne 0 ]; then
        echo "[FAILED] Could not copy image to $ip. Skipping machine."
        continue
    fi

    # 2. Execute the background change commands via SSH as the student user
    echo "Applying new background..."

    ssh -p "$LAB_PORT" -i ~/.ssh/id_onh_hub -o ConnectTimeout=3 "student@$ip" "
        export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/\$(id -u)/bus; dbus-send --session --dest=org.Cinnamon --type=method_call /org/Cinnamon org.Cinnamon.ShowDesktop" 2>/dev/null

    ssh -p "$LAB_PORT" -i ~/.ssh/id_onh_hub -o ConnectTimeout=3 "student@$ip" "
        # Export the D-Bus session for the student user
        export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/\$(id -u)/bus
        export DISPLAY=:0

        # Try Cinnamon schema
        gsettings set org.cinnamon.desktop.background picture-uri 'file://$REMOTE_DEST' 2>/dev/null
        
        # Try MATE schema (in case some machines run MATE)
        gsettings set org.mate.background picture-filename '$REMOTE_DEST' 2>/dev/null
    "

    echo "[SUCCESS] Commands sent to $ip"

done 3< "$IP_LIST"

echo "========================================"
echo "=== Bulk Wallpaper Update Complete ==="
