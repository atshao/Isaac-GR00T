#!/bin/bash
set -o errexit


docker run \
    --rm -it \
    --gpus all \
    --ipc=host \
    --ulimit memlock=-1 \
    --ulimit stack=67108864 \
    --name isaac-gr00t-export-onnx \
    -v $(pwd)/../data:/data \
    -w /workspace/gr00t \
    gr00t-dev \
uv run scripts/deployment/export_onnx_n1d6.py \
    --dataset_path /data/training-dataset \
    --model_path /data/fine-tuned \
    --output_dir /data/onnx \
    --video_backend decord \
    --embodiment_tag new_embodiment
