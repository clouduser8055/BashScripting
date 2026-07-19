#!/bin/bash

LOG_DIR="/mnt/b/AWS/BashScripting/logs"
ERROR_PATTERNS=("ERROR" "FATAL" "CRITICAL")
REPORT_FILE="/home/anuj_nahar/log_reports/log_analysis_report.txt"

echo "analysing log file" > "$REPORT_FILE"
echo "==================" >> "$REPORT_FILE"

echo -e "\nList of log files updated in last 24 hours" >> "$REPORT_FILE"
LOG_FILES=$(find $LOG_DIR -name "*.log" -mtime -1)
echo "$LOG_FILES" >> "$REPORT_FILE"

for LOG_FILES in $LOG_FILES; do

    echo -e "\n" >> "$REPORT_FILE"
    echo "===============================================" >> "$REPORT_FILE"
    echo "==============$LOG_FILES===============" >> "$REPORT_FILE"
    echo "===============================================" >> "$REPORT_FILE"

    for PATTERN in ${ERROR_PATTERNS[@]}; do

        echo -e "\nSearching $PATTERN logs in $LOG_FILES file" >> "$REPORT_FILE"
        grep "$PATTERN" "$LOG_FILES" >> "$REPORT_FILE"

        echo -e "\nNumber of $PATTERN logs found in $LOG_FILES file" >> "$REPORT_FILE"

        ERROR_COUNT=$(grep -c "$PATTERN" "$LOG_FILES")
        echo $ERROR_COUNT >> "$REPORT_FILE"

        if [ "$ERROR_COUNT" -gt 10 ]; then
            echo -e "\n ⚠️ Action Required: too many $PATTERN errors in log file $LOG_FILES"
        fi
    done

done

echo -e "\nLog analysis completed and report saved in: $REPORT_FILE"
