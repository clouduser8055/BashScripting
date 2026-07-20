#!/bin/bash
set -euo pipefail

disk_Threshold="80"
mem_Threshold="85"

disk_usage=$(df -h | grep ' /$' | awk '{print $5}' | cut -d"%" -f1)
echo -e "\nThe disk usage is : $disk_usage%"


used_memory=$(free | grep "Mem" | awk '{print $3}')
total_memory=$(free | grep "Mem" | awk '{print $2}')
percentage_used=$(("$used_memory" * 100 / "$total_memory"))

echo -e "\nThe memory usage is : $percentage_used%"

if (( "$disk_usage" > "$disk_Threshold" )); then
	echo -e "\n⚠️ WARNING: Disk usage is above ${disk_Threshold}%!"
else
	echo -e "\n👍 Disk status: Normal"
fi

if (( "$percentage_used" > "$mem_Threshold" )); then
	echo -e "\n⚠️ WARNING: Memory usage is above ${mem_Threshold}%!"
else
	echo -e "\n👍 Memory status: Normal"
fi



