#!/usr/bin/env bash

set -e
if [ "$#" != 3 ]; then
        echo "Usage: $0 <host> <port> <key or pattern>"
        exit 1
fi
HOSTS=$(redis-cli -c -h $1 -p $2 cluster nodes| cut -d" " -f2-| cut -d@ -f-1)
for pair in $HOSTS; do
        host=$(echo $pair|cut -d: -f-1)
        port=$(echo $pair|cut -d: -f2-)
        for key in $(redis-cli -c -h $host -p $port keys $3); do
                echo removing $key
                redis-cli -c -h $host -p $port del $key
        done
done