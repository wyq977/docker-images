FROM ubuntu:18.04

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Add Kitware APY Repository for newer version of cmake
# 1. Update essentials
RUN apt-get update -qq && apt-get install -qq -y \
    apt-transport-https ca-certificates gnupg software-properties-common wget
# 2. Obtain a copy of our signing key:
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -
# 3. Add the repository to your sources list and update
RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'

# Update git repo
RUN add-apt-repository ppa:git-core/ppa -y

# Add essential compilers for cmake
RUN apt-get update -qq && apt-get install -qq -y \
    # packages needed for vtk
    build-essential \
    # using the updated Kitware APT repo
    cmake \
    mesa-common-dev \
    freeglut3-dev \
    ninja-build \
    git \
    # packages required as per https://git.bsse.ethz.ch/iber/Publications/stopka-notch/blob/master/README.txt
    libboost-dev \
    doxygen \
    graphviz \
    # codecoverage
    lcov \
    curl \
    && rm -rf /var/lib/apt/lists/*

# release branch always raise error during cmake
WORKDIR /tmp
RUN git clone --single-branch --branch v8.2.0 https://gitlab.kitware.com/vtk/vtk.git && \
    mkdir /tmp/vtk-build

# No in-source build
WORKDIR /tmp/vtk-build
RUN cmake \
    -D CMAKE_BUILD_TYPE:STRING=Release \
    -D CMAKE_INSTALL_PREFIX:STRING=/usr/lib/vtk \
    -D BUILD_SHARED_LIBS:BOOL=OFF \
    /tmp/vtk

# build
RUN make --silent -j $(cat /proc/cpuinfo | grep processor | wc -l) VERBOSE=1 && \
    make install --silent

# clean up
WORKDIR /tmp
RUN rm -rf vtk && rm -rf vtk-build

# linked lib properly
# https://github.com/CogChameleon/ChromaTag/issues/2
RUN ldconfig -v

ENV VTK_DIR /usr/lib/vtk
ENV DEBIAN_FRONTEND=dialog

#https://wiki.ubuntu.com/DashAsBinSh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
