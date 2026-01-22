#!/bin/bash
set -o errexit


export LLM_DTYPE="${LLM_DTYPE:-fp16}"
export VIT_DTYPE="${VIT_DTYPE:-fp16}"
export DIT_DTYPE="${DIT_DTYPE:-fp16}"

export MAX_BATCH=${MAX_BATCH:-8}
export VIDEO_VIEWS="${VIDEO_VIEWS:-1}"


DIR_TOP="$(cd "$(dirname "$0")/.." >/dev/null 2>&1; pwd)"
DIR_GR00T="${DIR_TOP}/Isaac-GR00T"
DIR_DATA="${DIR_TOP}/data"

ONNX_PATH="${DIR_DATA}/onnx/llm-${LLM_DTYPE}_vit-${VIT_DTYPE}_dit-${DIT_DTYPE}"
ENGINE_PATH="${DIR_DATA}/engine/llm-${LLM_DTYPE}_vit-${VIT_DTYPE}_dit-${DIT_DTYPE}"


mkdir -p "${ENGINE_PATH}"
docker run \
    --rm -it \
    --net host \
    --runtime nvidia \
    --name isaac-gr00t-engine \
    -w /workspace/Isaac-GR00T \
    -e LLM_DTYPE=${LLM_DTYPE} \
    -e VIT_DTYPE=${VIT_DTYPE} \
    -e DIT_DTYPE=${DIT_DTYPE} \
    -e MAX_BATCH=${MAX_BATCH} \
    -e VIDEO_VIEWS=${VIDEO_VIEWS} \
    -v ${DIR_GR00T}:/workspace/Isaac-GR00T \
    -v ${ONNX_PATH}:/workspace/Isaac-GR00T/gr00t_onnx \
    -v ${ENGINE_PATH}:/workspace/Isaac-GR00T/gr00t_engine \
    isaac-gr00t-n1.5:amd64 \
bash -c " \
bash deployment_scripts/build_engine.sh; \
chown -R $(id -u):$(id -g) /workspace/Isaac-GR00T/gr00t_engine \
"
