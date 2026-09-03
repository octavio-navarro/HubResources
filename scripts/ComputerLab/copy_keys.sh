#!/bin/bash

# Ensure the script is run with sudo privileges to modify another user's home directory
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo or as root."
  exit 1
fi

SOURCE_USER="hub"
TARGET_USER="student"

SOURCE_HOME="/home/$SOURCE_USER"
TARGET_HOME="/home/$TARGET_USER"

# Check if target user actually exists on this machine
if ! id "$TARGET_USER" &>/dev/null; then
    echo "Error: Target user '$TARGET_USER' does not exist on this system."
    exit 1
fi

# Check if source keys exist
if [ ! -d "$SOURCE_HOME/.ssh" ]; then
    echo "Error: No .ssh directory found for source user '$SOURCE_USER'."
    exit 1
fi

echo "Copying SSH keys from $SOURCE_USER to $TARGET_USER..."

# 1. Create target .ssh directory if it doesn't exist
mkdir -p "$TARGET_HOME/.ssh"

# 2. Copy the authorized_keys file (and any actual key pairs if needed)
if [ -f "$SOURCE_HOME/.ssh/authorized_keys" ]; then
    cp "$SOURCE_HOME/.ssh/authorized_keys" "$TARGET_HOME/.ssh/"
    echo "-> authorized_keys copied."
fi

# Optional: Un-comment the line below if you also want to copy hub's private/public key pairs
# cp $SOURCE_HOME/.ssh/id_* $TARGET_HOME/.ssh/ 2>/dev/null

# 3. FIX PERMISSIONS (Crucial for OpenSSH compliance)
chmod 700 "$TARGET_HOME/.ssh"
chmod 600 "$TARGET_HOME/.ssh/"* 2>/dev/null

# 4. Change ownership to the student user and their group
# Dynamically queries the primary group of the student user
TARGET_GROUP=$(id -gn "$TARGET_USER")
chown -R "$TARGET_USER:$TARGET_GROUP" "$TARGET_HOME/.ssh"

echo "=== Migration Complete ==="
echo "SSH access mirrored to user '$TARGET_USER'."
