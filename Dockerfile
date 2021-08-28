FROM ubuntu:18.04 AS builder
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
    && apt-get install -qq --yes --no-install-recommends \
        autoconf \
        automake \
        build-essential \
        git \
        libkrb5-dev \
        libsodium-dev \
		libboost-all-dev \
        libtool \
        pkg-config \
		wget \
		unzip \
		cmake \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /opt/libzmq
RUN wget -q --no-check-certificate https://github.com/zeromq/libzmq/archive/refs/heads/master.zip && unzip master.zip -d . && rm master.zip
#RUN cd libzmq-master && ./autogen.sh \
#    && ./configure --prefix=/usr/local --with-libsodium --with-libgssapi_krb5 \
#    && make -j $(nproc) \
#    && make install
RUN cd libzmq-master && mkdir build && cd build \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DWITH_LIBSODIUM=ON -DBUILD_TESTS=OFF -DCMAKE_BUILD_TYPE=Release .. \
    && make -j $(nproc) \
    && make install
RUN wget --no-check-certificate -q https://github.com/zeromq/zmqpp/archive/refs/heads/develop.zip && unzip develop.zip -d . && rm develop.zip
RUN cd zmqpp-develop && mkdir build && cd build \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release .. \
    && make -j $(nproc) \
    && make install
RUN wget --no-check-certificate -q https://github.com/msgpack/msgpack-c/archive/refs/heads/cpp_master.zip && unzip cpp_master.zip 
RUN cd msgpack-c-cpp_master && mkdir build && cd build \
	&& cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DMSGPACK_CXX11=ON \
	&& make -j $(nproc) \
	&& make install

FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
    && apt-get install -qq --yes --no-install-recommends \
        libkrb5-dev \
        libsodium23 \
		libsodium-dev \
		libboost-all-dev \
        build-essential \
		cmake \
		pkg-config \
		vim \
		less \
		tmux \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local /usr/local
RUN ldconfig && ldconfig -p | grep libzmq
VOLUME /workspace
WORKDIR /workspace
CMD ["bash"]
