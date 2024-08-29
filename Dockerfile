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
            protobuf-compiler

            

# libkrb5-dev \ required for fbthrift not found -- fbthrift might not be needed
# epel-release not found
# fast-float not found. It is used to build folly - /home/riaggarwal/katran/_build/deps/folly/build/fbcode_builder/manifests/fast_float

# git clone https://github.com/google/double-conversion.git
# cd double-conversion
# cmake -DBUILD_SHARED_LIBS=ON .
# make
# sudo make install
# Can be replaced with tdnf install "double-conversion-devel" -- need to check

# go env -w GO111MODULE=ON
# go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
# go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
# cp /root/go/bin/protoc-gen-go-grpc /root/go/bin/protoc-gen-go_grpc