#!/bin/bash
echo "=================================="
echo "========= EC2 Ping Test =========="
echo "=================================="
cat EC2_list.txt | while read output
do
    ping -c 1 -W 1 "$output" > /dev/null
    if [ $? -eq 0 ]; then
    echo "\"$output\" EC2 Instance is up"
    else
    echo "\"$output\" EC2 Instance is down"
    fi
done
