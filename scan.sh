#!/bin/bash

LOG_FILE="/var/webserver_log/unauthorized.log"
COUNTRY_LOOKUP="geoiplookup"

sudo touch "$LOG_FILE"

UNAUTHORIZED_ENTRIES=$(sudo grep "Failed password\|Invalid user" /var/log/auth.log)

while read -r line; do
    IP=$(echo "$line" | awk '{print $(NF-3)}')

    COUNTRY=$($COUNTRY_LOOKUP "$IP" | awk -F ": " '{print $2}')

    DATE=$(date "+%Y-%m-%d %H:%M:%S")

    echo "$IP $COUNTRY $DATE" | sudo tee -a "$LOG_FILE" >/dev/null
done <<< "$UNAUTHORIZED_ENTRIES"

