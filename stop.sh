#!/bin/bash

pid=$(pgrep python3)

if [ -n "$pid" ]; then
    kill -9 "$pid"
else
    echo "Not found"
fi
#killall -q -e python3 raw_data.py

