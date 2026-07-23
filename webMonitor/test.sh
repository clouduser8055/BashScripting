#!/bin/bash
set -euo pipefail

urls_txt="${1:-}"

if [ -z "${1:-}" ] || [ ! -f "${1:-}" ]; then 
	echo -e "\nERROR: File is not found!"
	exit 1
fi

echo -e "\nFile verification is successfull."

tail -n +2 "$urls_txt" | while IFS= read -r url || [ -n "$url" ]; do

[ -z "$url" ] && continue

timestamp=$( date "+%Y-%m-%d %H:%M:%S" )
http_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")

if [ -z "$http_code" ] || [ "$http_code" = "000" ]; then
	echo -e "\nSite fails the check.."
	echo "Unable to check $url on $timestamp"
elif [ "$http_code" = "200" ];then
	echo -e "\n$url is UP ($http_code)"
else
	echo -e "\n$url is DOWN (HTTP Code: "$http_code")"
fi

done

