#!/bin/bash

# Define log file and country lookup command
LOG_FILE="/var/webserver_log/unauthorized.log"
COUNTRY_LOOKUP="geoiplookup"

# Ensure log file exists or create it
sudo touch "$LOG_FILE"

# Scan auth.log for unauthorized SSH access (use sudo for grep command)
UNAUTHORIZED_ENTRIES=$(sudo grep "Failed password\|Invalid user" /var/log/auth.log)

# Loop through each unauthorized entry
while read -r line; do
    # Extract IP address
    IP=$(echo "$line" | awk '{print $(NF-3)}')

    # Lookup country of origin
    COUNTRY=$($COUNTRY_LOOKUP "$IP" | awk -F ": " '{print $2}')

    # Get current date/time
    DATE=$(date "+%Y-%m-%d %H:%M:%S")

    # Append to log file
    echo "$IP $COUNTRY $DATE" | sudo tee -a "$LOG_FILE" >/dev/null
done <<< "$UNAUTHORIZED_ENTRIES"

