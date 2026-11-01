FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends python3 python3-venv python3-pip ca-certificates ffmpeg libglib2.0-0 libgl1 libgomp1 build-essential && rm -rf /var/lib/apt/lists/*
RUN python3 -m venv /opt/venv
ENV PATH=/opt/venv/bin:$PATH PIP_NO_CACHE_DIR=1 PIP_DISABLE_PIP_VERSION_CHECK=1
RUN python -m pip install --upgrade 'pip<26' 'setuptools>=71,<81' wheel
COPY constraints.txt /opt/constraints.txt
RUN python -m pip install --only-binary=:all: torch==2.8.0 torchvision==0.23.0 torchcodec==0.6.0 --index-url https://download.pytorch.org/whl/cpu
COPY lerobot /opt/lerobot
RUN apt-get update && apt-get install -y --no-install-recommends python3-dev && rm -rf /var/lib/apt/lists/*
RUN python -m pip install --index-url https://pypi.tuna.tsinghua.edu.cn/simple -c /opt/constraints.txt -e '/opt/lerobot[feetech]' && python -m pip check
ENV HF_HOME=/workspace/cache/huggingface OMP_NUM_THREADS=2 MKL_NUM_THREADS=2
WORKDIR /workspace
CMD ["/bin/bash"]