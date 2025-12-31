#!/bin/bash
set -o errexit


docker run \
    --rm -it \
    --gpus all \
    --ipc=host \
    --ulimit memlock=-1 \
    --ulimit stack=67108864 \
    --name isaac-gr00t-inference \
    -v $(pwd)/../data:/data \
    -w /workspace/gr00t \
    gr00t-dev \
uv run gr00t/eval/run_gr00t_server.py \
    --model-path /data/fine-tuned \
    --embodiment-tag NEW_EMBODIMENT \
    --execution-horizon 8 \
    --use-tensorrt \
    --trt-engine-path /data/engine
