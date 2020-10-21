FROM ubuntu:14.04
# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Get g++ for compiling, wget to download Boost, git to clone source code repo,
# and make to automate program compilation with Makefile provided
RUN apt-get update && apt-get install -qq -y \
    # necessary
    git build-essential wget cmake \
    && rm -rf /var/lib/apt/lists/*

################################################################################
#                           BOOST 1.57.0 (< 1.5.8 !)                           #
################################################################################
# to /usr/local 
# https://github.com/pblischak/boost-docker-test/blob/master/Dockerfile
# Boost include directories:/usr/local/include
# Boost library directories:/usr/local/lib
# 
# RUN apt-get update -qq && apt-get install -qq -y libboost-all-dev \
#     && rm -rf /var/lib/apt/lists/*
WORKDIR /tmp
RUN wget http://downloads.sourceforge.net/project/boost/boost/1.57.0/boost_1_57_0.tar.gz \
    && tar xfz boost_1_57_0.tar.gz \
    && rm boost_1_57_0.tar.gz \
    && cd boost_1_57_0 \
    && ./bootstrap.sh --prefix=/usr/local \
    && ./b2 install \
    && rm -rf ../boost_1_57_0


################################################################################
#                                  VTK 5.10.1                                  #
################################################################################
RUN apt-get update -qq && apt-get install -qq -y \
    # packages needed for vtk
    mesa-common-dev mesa-utils libosmesa6 libxt-dev \
    # packages needed for vtk (according to group share)
    libpng-dev libjpeg-dev libxxf86vm1 libxxf86vm-dev libxi-dev libxrandr-dev mesa-common-dev mesa-utils-extra libgl1-mesa-dev libglapi-mesa \
    doxygen \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN git clone --single-branch --branch v5.10.1 https://gitlab.kitware.com/vtk/vtk.git && \
    mkdir /tmp/vtk-build

# out-of-source build
WORKDIR /tmp/vtk-build
RUN cmake -Wno-dev \
    -D CMAKE_BUILD_TYPE:STRING=Release \
    -D BUILD_SHARED_LIBS:BOOL=ON \
    -D CMAKE_INSTALL_PREFIX:STRING=/usr/lib/vtk \
    -D CMAKE_C_FLAGS:STRING=-DGLX_GLXEXT_LEGACY \
    -D CMAKE_CXX_FLAGS:STRING=-DGLX_GLXEXT_LEGACY \
    /tmp/vtk

# build
RUN make --silent -j $(cat /proc/cpuinfo | grep processor | wc -l) VERBOSE=1 && \
    make install --silent


################################################################################
#                                   LBIBCELL                                   #
################################################################################
WORKDIR /tmp
RUN git clone https://github.com/wyq977/LBIBCell.git /tmp/lbibcell \
    && cd /tmp/lbibcell && mkdir build && cd build \
    && cmake -DVTK_DIR=/usr/lib/vtk/lib/vtk-5.10 -DCMAKE_BUILD_TYPE=Release .. \
    && make --silent -j $(cat /proc/cpuinfo | grep processor | wc -l) VERBOSE=1


################################################################################
#                                   CLEAN UP                                   #
################################################################################
# clean up
WORKDIR /tmp
RUN rm -rf vtk && rm -rf vtk-build && rm -rf boost_1_57_0

# linked lib properly
# https://github.com/CogChameleon/ChromaTag/issues/2
RUN ldconfig -v

ENV VTK_DIR /usr/lib/vtk
ENV DEBIAN_FRONTEND=dialog

#https://wiki.ubuntu.com/DashAsBinSh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
