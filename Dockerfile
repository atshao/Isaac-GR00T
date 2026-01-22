FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu22.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-dev
    
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONPATH=/workspace:${PYTHONPATH}

# System dependencies
RUN apt update && \
    apt install -y tzdata && \
    ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
    apt install -y netcat dnsutils && \
    apt-get update && \
    apt-get install -y libgl1-mesa-glx git libvulkan-dev \
    zip unzip wget curl git git-lfs build-essential cmake \
    vim less sudo htop ca-certificates man tmux ffmpeg tensorrt \
    libglib2.0-0 libsm6 libxext6 libxrender-dev

RUN pip install --upgrade pip setuptools

WORKDIR /workspace
COPY pyproject.toml .
RUN pip install -e .[base] nvidia-modelopt
RUN pip install flash-attn==2.8.2 --no-build-isolation

COPY getting_started /workspace/getting_started
COPY scripts /workspace/scripts
COPY demo_data /workspace/demo_data
COPY gr00t /workspace/gr00t
RUN pip install -e . --no-deps
