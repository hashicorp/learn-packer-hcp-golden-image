#!/bin/bash

# Get IP from terraform output
HASHICUPS_IP=$(terraform output | grep -i hashicups | awk -F'"' '{print $2}')
# Interval in seconds
CURL_INTERVAL=5

echo "Hashicups address: $HASHICUPS_IP"
echo -e "Making requests to hashicups service every $CURL_INTERVAL seconds.\nPress ctrl+c to quit.\n"

while true; do 
    curl $HASHICUPS_IP:19090/coffees; sleep $CURL_INTERVAL; 
done