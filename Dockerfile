FROM nvidia/cuda:10.2-devel-ubuntu18.04
WORKDIR /style
LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"
ENV CUDNN_VERSION 7.6.5.32
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn7=$CUDNN_VERSION-1+cuda10.2 \
libcudnn7-dev=$CUDNN_VERSION-1+cuda10.2 \
&& \
    apt-mark hold libcudnn7 && \
    rm -rf /var/lib/apt/lists/*

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

#COPY nv-tensorrt-repo-ubuntu1804-cuda10.2-trt6.0.1.8-ga-20191108_1-1_amd64.deb /tmp/trt.deb
RUN tag='cuda10.2-trt6.0.1.8-ga-20191108' && \
    wget https://www.dropbox.com/s/vr2ndcfsvp1004g/nv-tensorrt-repo-ubuntu1804-cuda10.2-trt6.0.1.8-ga-20191108_1-1_amd64.deb?dl=0 && \
    dpkg -i nv-tensorrt-repo-ubuntu1804-cuda10.2-trt6.0.1.8-ga-20191108_1-1_amd64.deb?dl=0 && \
    #dpkg -i /tmp/trt.deb && \
    apt-key add /var/nv-tensorrt-repo-${tag}/7fa2af80.pub && \
    apt-get update && \
    apt-get install -y libcudnn7-dev=7.6.5.32-1+cuda10.2 \
    libnvinfer6=6.0.1-1+cuda10.2 \
    libnvinfer-plugin6=6.0.1-1+cuda10.2 \
    libnvparsers6=6.0.1-1+cuda10.2 \
    libnvonnxparsers6=6.0.1-1+cuda10.2 \
    libnvinfer-bin=6.0.1-1+cuda10.2 \
    libnvinfer-dev=6.0.1-1+cuda10.2 \
    libnvinfer-plugin-dev=6.0.1-1+cuda10.2 \
    libnvparsers-dev=6.0.1-1+cuda10.2 \
    libnvonnxparsers-dev=6.0.1-1+cuda10.2 \
    libnvinfer-samples=6.0.1-1+cuda10.2 \
    tensorrt=6.0.1.8-1+cuda10.2 \
    python3-libnvinfer=6.0.1-1+cuda10.2 \
    python3-libnvinfer-dev=6.0.1-1+cuda10.2 && \
    rm nv-tensorrt-repo-ubuntu1804-cuda10.2-trt6.0.1.8-ga-20191108_1-1_amd64.deb?dl=0 && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/nv-tensorrt-repo-cuda10.2-trt6.0.1.8-ga-20191108

RUN rm /etc/apt/sources.list.d/nv-tensorrt-cuda10.2-trt6.0.1.8-ga-20191108.list && \
    apt-get update && \
    apt-get install -y pkg-config libavcodec-dev libavformat-dev libavdevice-dev \
    python3-dev libxml2-dev libxslt-dev \
	libgtk2.0-dev pkg-config libv4l-dev \
	libavfilter-dev libopus-dev libvpx-dev libsrtp2-dev && \
    rm -rf /var/lib/apt/lists/*

RUN	pip3 install setuptools wheel && \
    pip3 install flask aiohttp aiortc Pillow pycuda torch && \
    rm -rf /root/.cache/pip/http

RUN git clone https://github.com/bbbrtk/aiortc.git && \
    wget https://www.dropbox.com/s/wb3y0l6irpt9oma/style_transfer.tar.gz && \
    tar xzvf style_transfer.tar.gz && \
    rm style_transfer.tar.gz && \
    mv LinearStyleTransfer_nongit LinearStyleTransfer

