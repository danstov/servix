#!/usr/bin/env bash

./server-stats.sh &
PID=$!

echo "Starting Server Monitor... "
read -s -n 1 key
[[ $key == "q" ]] && kill $PID