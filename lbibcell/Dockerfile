FROM ubuntu:16.04

################################################################################
#                                     MISC                                     #
################################################################################
# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# pass version and lib directory
ARG BOOST_VERSION=1.54.0
ARG BOOST_INSTALL_PREFIX=/usr/local
ARG VTK_VERSION=5.10.1
ARG VTK_INSTALL_PREFIX=/usr/local

ENV BOOST_VERSION=$BOOST_VERSION
ENV BOOST_INSTALL_PREFIX=${BOOST_INSTALL_PREFIX}
ENV VTK_VERSION=${VTK_VERSION}
ENV VTK_INSTALL_PREFIX=${VTK_INSTALL_PREFIX}

# Get g++ for compiling, wget to download Boost, git to clone source code repo,
# and make to automate program compilation with Makefile provided
RUN apt-get update && apt-get install -qq -y \
        git wget cmake software-properties-common \
        && rm -rf /var/lib/apt/lists/*


################################################################################
#                                   g++ 4.8                                    #
################################################################################
# Get g++ from toolchain
RUN add-apt-repository --yes ppa:ubuntu-toolchain-r/test \
    && apt-get update && apt-get install -qq -y gcc-4.8 g++-4.8 \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 20 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 20


################################################################################
#                                    BOOST                                     #
################################################################################
# only version 1.54.0 ~ 1.57.0 were tested (< 1.5.8 !)
# Install to /usr/local
# https://github.com/pblischak/boost-docker-test/blob/master/Dockerfile
# Boost include directories:/usr/local/include
# Boost library directories:/usr/local/lib
# TODO: maunally install Boost version
RUN apt-get update && apt-get install -qq -y libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

# WORKDIR /tmp
# RUN wget https://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION}/boost_$( echo ${BOOST_VERSION} | tr '.' '_' ).tar.gz \
#     && tar xfz boost_$( echo ${BOOST_VERSION} | tr '.' '_' ).tar.gz \
#     && rm boost_$( echo ${BOOST_VERSION} | tr '.' '_' ).tar.gz \
#     && cd boost_$( echo ${BOOST_VERSION} | tr '.' '_' ) \
#     && ./bootstrap.sh --prefix=${BOOST_INSTALL_PREFIX} \
#     && ./b2 install
# # clean up
# WORKDIR /tmp
# RUN rm -rf boost_$( echo ${BOOST_VERSION} | tr '.' '_' )


################################################################################
#                                     VTK                                      #
################################################################################
RUN apt-get update -qq && apt-get install -qq -y \
    # packages needed for vtk
    mesa-common-dev mesa-utils libosmesa6 libxt-dev \
    # packages needed for vtk (according to group share)
    libpng-dev libjpeg-dev libxxf86vm1 libxxf86vm-dev libxi-dev libxrandr-dev mesa-common-dev mesa-utils-extra libgl1-mesa-dev libglapi-mesa \
    doxygen \
    && rm -rf /var/lib/apt/lists/*

# http://www.labmec.org.br/wiki/howto/qt_qwt_vtk_ubuntu
RUN apt-get update && apt-get install -qq -y libvtk5.10 libvtk5-dev \
    && rm -rf /var/lib/apt/lists/*

# # https://github.com/lukin0110/docker-vtk-python/blob/master/Dockerfile
# WORKDIR /tmp
# RUN wget http://www.vtk.org/files/release/$( echo ${VTK_VERSION} | cut -d. -f1-2 )/VTK-${VTK_VERSION}.tar.gz \
#     && tar -zxvf VTK-${VTK_VERSION}.tar.gz
# RUN git clone --single-branch --branch v${VTK_VERSION} https://gitlab.kitware.com/vtk/vtk.git \
#     && mkdir /tmp/vtk-build

# # out-of-source build
# # https://stackoverflow.com/questions/28761702/getting-error-glintptr-has-not-been-declared-when-building-vtk-on-linux
# # Not sure if these two options are needed
# # -D VTK_USE_RENDERING:BOOL=OFF \
# # -D VTK_USE_DISPLAY:BOOL=OFF \
# WORKDIR /tmp/vtk-build
# RUN cmake -Wno-dev \
#     -D CMAKE_BUILD_TYPE:STRING=Release \
#     -D BUILD_SHARED_LIBS:BOOL=ON \
#     -D CMAKE_INSTALL_PREFIX:STRING=${VTK_INSTALL_PREFIX} \
#     -D CMAKE_C_FLAGS:STRING=-DGLX_GLXEXT_LEGACY \
#     -D CMAKE_CXX_FLAGS:STRING=-DGLX_GLXEXT_LEGACY \
#     /tmp/vtk

# # build
# RUN make --silent -j $(cat /proc/cpuinfo | grep processor | wc -l) VERBOSE=1 \
#     && make install --silent

# # clean up
# WORKDIR /tmp
# RUN rm -rf /tmp/vtk && rm -rf /tmp/vtk-build


################################################################################
#                                   CLEAN UP                                   #
################################################################################
# linked lib properly
# https://github.com/CogChameleon/ChromaTag/issues/2
RUN ldconfig -v

ENV VTK_DIR=${VTK_INSTALL_PREFIX}/lib/vtl-${VTK_VERSION}
ENV DEBIAN_FRONTEND=dialog

#https://wiki.ubuntu.com/DashAsBinSh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
