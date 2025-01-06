#!/bin/bash

cleanup() {
    echo -e "\nContainer stopped, performing cleanup..."
    /usr/bin/run_wm.sh -s
}

trap 'cleanup' SIGTERM
trap 'cleanup' SIGINT

/usr/bin/run_wm.sh $@ &

wait $!

