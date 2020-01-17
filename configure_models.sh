cd /style/TensorRT && \
mkdir build && \
cd build && \
CUDA_V=$(echo 'from torch.cuda import get_device_capability; print(get_device_capability())' | python3 | sed 's/[^0-9]*//g') && \
cmake .. -DTRT_LIB_DIR=$TRT_RELEASE/lib \
         -DTRT_BIN_DIR=`pwd`/out        \
         -DBUILD_SAMPLES=OFF            \
         -DCUDNN_VERSION=7.5            \
         -DGPU_ARCHS="$CUDA_V"          \
         -DCUDA_VERSION="10.1"          && \
make -j$(nproc) && \
make install && \
cd /style/LinearStyleTransfer && \
./utils/compile_full_model.py && \
./utils/make_engine.sh

