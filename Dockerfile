FROM mcr.microsoft.com/cbl-mariner/base/core:2.0

RUN tdnf install ethtool vim openssh-server git mariner-repos-extended WALinuxAgent cloud-init ca-certificates wget double-conversion libmnl libdwarf elfutils  -y

# build_katran.sh things
RUN tdnf install cmake git elfutils-libelf-devel libmnl xz-devel re2-devel libatomic libsodium fmt-devel -y 
RUN tdnf install -y \
            boost-devel \
            boost-static \
            lz4-devel \
            xz-devel \
            snappy-devel \
            zlib-devel \
            zlib-static \
            glog \
            python3 \
            openssl-devel \
            elfutils-devel elfutils-devel-static \
            libunwind-devel \
            bzip2-devel \
            binutils-devel \
            clang \
            flex  
            
RUN tdnf install -y \
            golang \
            build-essential \
            glog-devel \
            libmnl-devel \
            libsodium-devel \
            bc \
            libevent-devel \
            protobuf-compiler \
            double-conversion-devel

RUN mkdir /usr/include/fast_float 
RUN wget -P /usr/include/fast_float https://github.com/fastfloat/fast_float/releases/download/v6.1.4/fast_float.h

# git clone https://github.com/winlibs/liblzma.git
# cd liblzma
# ccmake .
# # Press c for configuration then c again then g for generation
# make
# sudo make install 

            

# libkrb5-dev \ required for fbthrift not found -- fbthrift might not be needed
# epel-release not found

# go env -w GO111MODULE=ON
# go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
# go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
# cp /root/go/bin/protoc-gen-go-grpc /root/go/bin/protoc-gen-go_grpc