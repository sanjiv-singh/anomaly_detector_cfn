#!/bin/bash

pid=$(pgrep python3)

if [ -n "$pid" ]; then
    kill -9 "$pid"
else
    echo "Not found"
fi

