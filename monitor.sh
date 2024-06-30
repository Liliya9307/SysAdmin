#!/bin/bash

# Path to monitor log file
MONITOR_LOG="/var/webserver_monitor/unauthorized.log"

# Check if there are new entries
if [ -s "$MONITOR_LOG" ]; then
    # Send email with log content
    mail -s "Unauthorized Access Detected" your_email@example.com < "$MONITOR_LOG"
else
    # If no unauthorized access detected
    mail -s "No Unauthorized Access" your_email@example.com <<< "No unauthorized access detected."
fi
