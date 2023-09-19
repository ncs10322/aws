#!/bin/bash
echo "=================================="
echo "========= EC2 Ping Test =========="
echo "=================================="
cat EC2_list.txt | while read IP_ADDRESS
do
    ping -c 1 -W 1 "$IP_ADDRESS" > /dev/null
    if [ $? -eq 0 ]; then
    echo "\"$IP_ADDRESS\" EC2 Instance is up"
    else
    echo "\"$IP_ADDRESS\" EC2 Instance is down"
    fi
done