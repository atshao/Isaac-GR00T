#!/bin/bash
set -o errexit


LLM_DTYPE="${LLM_DTYPE:-fp16}"
VIT_DTYPE="${VIT_DTYPE:-fp16}"
DIT_DTYPE="${DIT_DTYPE:-fp16}"


DIR_TOP="/workspace"
DIR_GR00T="${DIR_TOP}/Isaac-GR00T"
DIR_SCRIPTS="${DIR_GR00T}/deployment_scripts"

DIR_DATA="${DIR_TOP}/data"
MODEL_PATH="${DIR_DATA}/fine-tuned"
DATASET_PATH="${DIR_DATA}/training-dataset"
ONNX_PATH="${DIR_DATA}/onnx/llm-${LLM_DTYPE}_vit-${VIT_DTYPE}_dit-${DIT_DTYPE}"


docker run \
    --rm -it \
    --net host \
    --gpus all \
    --name isaac-gr00t-onnx \
    -v ~/.cache/huggingface:/root/.cache/huggingface \
    -v $(pwd)/../Isaac-GR00T:/workspace/Isaac-GR00T \
    -v $(pwd)/../data:/workspace/data \
    -e PYTHONPATH=${DIR_GR00T} \
    -w ${DIR_TOP} \
    isaac-gr00t-n1.5:amd64 \
bash -c "\
python3 ${DIR_SCRIPTS}/export_onnx.py \
    --dataset-path ${DATASET_PATH} \
    --model-path ${MODEL_PATH} \
    --onnx-model-path ${ONNX_PATH} \
    --embodiment-tag new_embodiment \
    --data-config so100_dualcam \
    --llm-dtype ${LLM_DTYPE} \
    --vit-dtype ${VIT_DTYPE} \
    --dit-dtype ${DIT_DTYPE}; \
chown -R $(id -u):$(id -g) ${DIR_DATA} \
"
