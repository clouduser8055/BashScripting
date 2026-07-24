#!/bin/bash
set -euo pipefail

if ! command -v docker &> /dev/null; then
	echo "Docker is Nowhere to be found!"
	exit 1
fi

doc_ver=$( docker -v )

echo "Docker Loading......"
echo -e "\n============================"
echo -e "\n$doc_ver"

cont_num=$(docker ps --filter "status=exited" -q | wc -l )
img_num=$(docker images --filter "dangling=true" -q | wc -l )
net_num=$(docker network ls --filter "dangling=true" -q | wc -l)

echo -e "\nContainer reclaimed space..."
docker container prune -f
echo -e "\nImage reclaimed space..."
docker image prune -f
echo -e "\nNetwork reclaimed space..."
docker network prune -f

echo -e "\nTotal Containers Removed: $cont_num"
echo -e "\nTotal Images Removed: $img_num"
echo -e "\nTotal Networks Removed: $net_num"

echo "--- Overall docker disk usage ---" && docker system df 


