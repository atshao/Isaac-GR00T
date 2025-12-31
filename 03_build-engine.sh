#!/bin/bash
set -o errexit


docker run \
    --rm -it \
    --gpus all \
    --ipc=host \
    --ulimit memlock=-1 \
    --ulimit stack=67108864 \
    --name isaac-gr00t-build-engine \
    -v $(pwd)/../data:/data \
    -w /workspace/gr00t \
    gr00t-dev \
uv run scripts/deployment/build_tensorrt_engine.py \
    --onnx /data/onnx/dit_model.onnx \
    --engine /data/engine \
    --precision fp16
