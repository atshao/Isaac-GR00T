#!/bin/bash
set -o errexit


docker build \
    --network host \
    -f orin.Dockerfile \
    -t isaac-gr00t-n1.5:l4t-jp6.2 \
    .

