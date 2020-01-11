FROM nvidia/cuda:10.2-runtime-ubuntu18.04
WORKDIR /style
LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"
ENV CUDNN_VERSION 7.6.5.32
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn7=$CUDNN_VERSION-1+cuda10.2 \
&& \
    apt-mark hold libcudnn7 && \
    rm -rf /var/lib/apt/lists/*


RUN apt-get update && apt-get install -y software-properties-common && \
	apt-get install -y apt-utils && \
	apt-get install -y curl && \
	add-apt-repository ppa:git-core/ppa && \
	apt-get update && \
	apt-get install -y git && \
	curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
	apt-get install -y git-lfs && \
	apt-get install -y python3 && \
	apt-get install -y python3-pip && \
	apt-get install -y vim ranger

RUN git clone https://github.com/kamieen03/style-transfer-net.git

RUN git clone https://github.com/bbbrtk/aiortc.git && \
	apt-get install -y libavcodec-dev libavformat-dev libavdevice-dev && \
	apt-get install -y libgtk2.0-dev pkg-config libv4l-dev && \
	apt-get install -y libavfilter-dev libopus-dev libvpx-dev libsrtp2-dev && \
	pip3 install flask aiohttp aiortc

COPY  nv-tensorrt-repo-ubuntu1804-cuda10.2-trt6.0.1.8-ga-20191108_1-1_amd64.deb /tmp/trt.deb
RUN tag='cuda10.2-trt6.0.1.8-ga-20191108' && \
    dpkg -i /tmp/trt.deb && \
    apt-key add /var/nv-tensorrt-repo-${tag}/7fa2af80.pub && \
    apt-get update && \
    apt-get install -y libcudnn7-dev=7.6.5.32-1+cuda10.2 && \
    apt-get install -y libnvinfer6=6.0.1-1+cuda10.2 && \
    apt-get install -y libnvinfer-plugin6=6.0.1-1+cuda10.2 && \
    apt-get install -y libnvparsers6=6.0.1-1+cuda10.2 && \
    apt-get install -y libnvonnxparsers6=6.0.1-1+cuda10.2 && \
    apt-get install -y libnvinfer-bin=6.0.1-1+cuda10.2 && \
    apt-get install -y libnvinfer-dev=6.0.1-1+cuda10.2 && \
    apt-get install -y libnvinfer-plugin-dev=6.0.1-1+cuda10.2 && \
    apt-get install -y libnvparsers-dev=6.0.1-1+cuda10.2 && \
    apt-get install -y libnvonnxparsers-dev=6.0.1-1+cuda10.2 && \
    apt-get install -y libnvinfer-samples=6.0.1-1+cuda10.2 && \
    apt-get install -y tensorrt && \
    apt-get install -y python3-libnvinfer-dev

RUN pip3 install torch

