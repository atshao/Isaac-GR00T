#!/bin/bash
set -o errexit


LLM_DTYPE="${LLM_DTYPE:-fp16}"
VIT_DTYPE="${VIT_DTYPE:-fp16}"
DIT_DTYPE="${DIT_DTYPE:-fp16}"
DENOISING_STEPS="${DENOISING_STEPS:-4}"


DIR_TOP="/workspace"
DIR_GR00T="${DIR_TOP}/Isaac-GR00T"
DIR_SCRIPTS="${DIR_GR00T}/scripts"

DIR_DATA="${DIR_TOP}/data"
MODEL_PATH="${DIR_DATA}/fine-tuned"
ENGINE_PATH="${DIR_DATA}/engine/llm-${LLM_DTYPE}_vit-${VIT_DTYPE}_dit-${DIT_DTYPE}"


docker run \
    --rm -it \
    --net host \
    --gpus all \
    --runtime nvidia \
    --name isaac-gr00t-inference \
    -v $(pwd)/../Isaac-GR00T:/workspace/Isaac-GR00T \
    -v $(pwd)/../data:/workspace/data \
    -e PYTHONPATH=${DIR_GR00T} \
    -w ${DIR_TOP} \
    isaac-gr00t-n1.5:amd64 \
python3 ${DIR_SCRIPTS}/inference_service.py \
    --server \
    --use-tensorrt \
    --model-path ${MODEL_PATH} \
    --data-config so100_dualcam \
    --embodiment-tag new_embodiment \
    --denoising-steps ${DENOISING_STEPS} \
    --trt-engine-path ${ENGINE_PATH} \
    --llm-dtype ${LLM_DTYPE} \
    --vit-dtype ${VIT_DTYPE} \
    --dit-dtype ${DIT_DTYPE}

