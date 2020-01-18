FROM nvidia/cuda:10.1-devel-ubuntu18.04
WORKDIR /style
LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"
ENV CUDNN_VERSION 7.6.5.32
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

#CUDA
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn7=$CUDNN_VERSION-1+cuda10.1 \
libcudnn7-dev=$CUDNN_VERSION-1+cuda10.1 \
&& \
    apt-mark hold libcudnn7 && \
    rm -rf /var/lib/apt/lists/*

#BASIC UTILITIES
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
        apt-utils && \
    add-apt-repository ppa:git-core/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
    wget \
        git \
    python3 \
    python3-pip \
    vim \
    ranger && \
        curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
        apt-get install -y git-lfs && \
    rm -rf /var/lib/apt/lists/*

#TENSORRT
RUN tag='cuda10.1-trt6.0.1.5-ga-20190913' && \
    wget https://www.dropbox.com/s/tdp2trqockwewpy/nv-tensorrt-repo-ubuntu1804-cuda10.1-trt6.0.1.5-ga-20190913_1-1_amd64.deb?dl=0 && \
    dpkg -i nv-tensorrt-repo-ubuntu1804-cuda10.1-trt6.0.1.5-ga-20190913_1-1_amd64.deb?dl=0 && \
    apt-key add /var/nv-tensorrt-repo-${tag}/7fa2af80.pub && \
    apt-get update && \
    apt-get install -y libcudnn7-dev=7.6.5.32-1+cuda10.1 \
    libnvinfer6=6.0.1-1+cuda10.1 \
    libnvinfer-plugin6=6.0.1-1+cuda10.1 \
    libnvparsers6=6.0.1-1+cuda10.1 \
    libnvonnxparsers6=6.0.1-1+cuda10.1 \
    libnvinfer-bin=6.0.1-1+cuda10.1 \
    libnvinfer-dev=6.0.1-1+cuda10.1 \
    libnvinfer-plugin-dev=6.0.1-1+cuda10.1 \
    libnvparsers-dev=6.0.1-1+cuda10.1 \
    libnvonnxparsers-dev=6.0.1-1+cuda10.1 \
    libnvinfer-samples=6.0.1-1+cuda10.1 \
    tensorrt=6.0.1.5-1+cuda10.1 \
    python3-libnvinfer=6.0.1-1+cuda10.1 \
    python3-libnvinfer-dev=6.0.1-1+cuda10.1 && \
    rm nv-tensorrt-repo-ubuntu1804-cuda10.1-trt6.0.1.5-ga-20190913_1-1_amd64.deb?dl=0 && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/nv-tensorrt-repo-cuda10.1-trt6.0.1.5-ga-20190913

#LIBS
RUN rm /etc/apt/sources.list.d/nv-tensorrt-cuda10.1-trt6.0.1.5-ga-20190913.list && \
    apt-get update && \
    apt-get install -y pkg-config libavcodec-dev libavformat-dev libavdevice-dev \
    python3-dev libxml2-dev libxslt-dev \
        libgtk2.0-dev pkg-config libv4l-dev \
        libavfilter-dev libopus-dev libvpx-dev libsrtp2-dev && \
    rm -rf /var/lib/apt/lists/*

#PIP
RUN pip3 install setuptools wheel && \
    pip3 install flask aiohttp aiortc Pillow pycuda torch && \
    pip3 install cmake protobuf onnx==1.5.0 onnx-simplifier && \
    rm -rf /root/.cache/pip/http

#REPOS
RUN git clone https://github.com/bbbrtk/aiortc.git && \
    git clone https://github.com/kamieen03/style-transfer-server && \
    mv style-transfer-server LinearStyleTransfer && \
    git clone https://github.com/NVIDIA/TensorRT && \
    cd TensorRT && \
    git checkout daacf1537c9310ab9d4a7e8a7b33cb3739289a32 && \
    git submodule update --init --recursive && \
    cd /style && \
    wget https://raw.githubusercontent.com/bonczol/style-docker/master/configure_models.sh && \
    chmod 755 configure_models.sh

