#!/bin/bash
# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0


# Get IPs from terraform output
HASHICUPS_IP_EAST=$(terraform output -raw hashicups_east_ip)
HASHICUPS_IP_WEST=$(terraform output -raw hashicups_west_ip)

# Interval in seconds
CURL_INTERVAL=5

echo "HashiCups address (EAST): $HASHICUPS_IP_EAST"
echo "HashiCups address (WEST): $HASHICUPS_IP_WEST"
echo -e "Making requests to hashicups services every $CURL_INTERVAL seconds.\nPress ctrl+c to quit."

while true; do 
    echo -e "\n\nHashiCups (EAST) response:"
    curl $HASHICUPS_IP_EAST:19090/coffees; sleep $CURL_INTERVAL; 
    echo -e "\n\nHashiCups (WEST) response:"
    curl $HASHICUPS_IP_WEST:19090/coffees; sleep $CURL_INTERVAL; 
done