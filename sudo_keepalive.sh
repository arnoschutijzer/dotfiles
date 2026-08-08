#!/bin/zsh

if ! sudo -v; then
    echo "sudo declined."
    exit 1
fi

# kill -0 guards the loop against a caller that dies without running the trap.
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" 2>/dev/null || exit
done &

SUDO_KEEPALIVE_PID=$!
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT INT TERM
