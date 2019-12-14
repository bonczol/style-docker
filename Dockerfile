FROM nvidia/cuda:10.1-runtime-ubuntu18.04
WORKDIR /style
LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"
ENV CUDNN_VERSION 7.6.5.32
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn7=$CUDNN_VERSION-1+cuda10.1 \
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
	apt-get install -y python3 && \
	apt-get install -y python3-pip && \
	git clone https://github.com/kamieen03/distiller.git && \
	cd distiller && \
	pip3 install -e . && \
	pip3 install cmake && \
	apt-get install -y make

RUN curl -s https://raw.githubusercontent.com/kamieen03/style-transfer-net/master/utils/install_opencv.sh | bash 



