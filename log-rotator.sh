#!/bin/bash 
set -euo pipefail

log_Dir="/home/anuj_nahar/log_files" 
backup_Dir="/home/anuj_nahar/backup_Dir" 

echo -e "\nChecking log files......."
echo "========================="
echo -e "\n"

if [ -d "$log_Dir" ]; then
	log_files=$(find "$log_Dir" -name "*.log")

	echo "$log_files"

else 
	echo "ERROR: files doesn't exist"
fi

echo -e "\nChecking availability of backup directory..."
echo "============================================"

if [ ! -d "$backup_Dir" ]; then 
	echo -e "\nDirectory doesn't exist, Creating one now...."
	mkdir -p "$backup_Dir"
	echo -e "\n$backup_Dir is successfully created."
else
	echo -e "\nBackup Directory already exists!"
fi



for log_files in $log_files; do 
	log_file=$(basename "$log_files")
	echo -e "\nEvaluating the size of the $log_file....."
	echo -e "\n========================================="
	log_size=$(stat -c %s $log_files)
	echo -e "\n$log_size"
	if [ "$log_size" -gt  5000 ];then
		echo -e "\n$log_file file need to be compressed⚠️"
		timestamp=$(date +%Y-%m-%d_%H:%M:%S)
		gzip -c $log_files > $backup_Dir/"$log_file"_$timestamp.txt.gz
		echo -e "\n✅ $log_file file is successfully Compressed."
		echo -e "\n🚮Clearing the active $log_file file......"
		> $log_files
		echo -e "\n✔️Empty $log_file file Successfully."
	else
		echo -e "\nSize of the $log_file file is Normal👍."

	fi
done

echo -e "\n🔎 Searching files older than 30 days and 🚮 Deleting them at once...."
echo -e "\n======================================================================="
find $backup_Dir -name "*.txt.gz" -mtime +30 -delete
	


