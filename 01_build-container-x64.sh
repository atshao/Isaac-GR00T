#!/bin/bash
set -o errexit


docker build \
    --network host \
    -f Dockerfile \
    -t isaac-gr00t-n1.5:amd64 \
    .

