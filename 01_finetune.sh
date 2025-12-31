#!/bin/bash
set -o errexit


docker run \
    --rm -it \
    --gpus all \
    --ipc host \
    --ulimit memlock=-1 \
    --ulimit stack=67108864 \
    --name isaac-gr00t-finetune \
    -e CUDA_VISIBLE_DEVICES=0 \
    -v $(pwd)/../data:/data \
    -v $HOME/.cache/huggingface:/root/.cache/huggingface \
    -w /workspace/gr00t \
    gr00t-dev \
uv run gr00t/experiment/launch_finetune.py \
    --base-model-path nvidia/GR00T-N1.6-3B \
    --dataset-path /data/training-dataset \
    --modality-config-path examples/SO100/so100_config.py \
    --embodiment-tag NEW_EMBODIMENT \
    --num-gpus 1 \
    --output-dir /data/fine-tuned \
    --save-total-limit 5 \
    --save-steps 1000 \
    --max-steps 1000 \
    --global-batch-size 32 \
    --video-backend decord \
    --color-jitter-params brightness 0.3 contrast 0.4 saturation 0.5 hue 0.08 \
    --dataloader-num-workers 4
