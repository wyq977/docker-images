#!/bin/sh
set -e                    # print the script and exit when non-zero value return

BOOST_VERSION=${1:-1.54.0}
BOOST_INSTALL_PREFIX=${2:-/usr/local}
VTK_VERSION=${3:-5.10.1}
VTK_INSTALL_PREFIX=${4:-/usr/local}

if [ $# -eq 0 ]
  then
    echo "Building Docker Image using default values..."
elif [ $# -ne 4 ]
  then
    echo "Usage: ./build-lbibcell-docker.sh BOOST_VERSION, BOOST_INSTALL_PREFIX VTK_VERSION VTK_INSTALL_PREFIX"
    echo "i.e.   ./build-lbibcell-docker.sh 1.54.0 /usr/local 5.10.1 /usr/local"
    exit
fi

ORG="wyq977"

echo "Distro   :\t Ubuntu-14.04"
echo "Compiler :\t gcc-4.8"
echo "Boost    :\t ${BOOST_VERSION} install to ${BOOST_INSTALL_PREFIX}"
echo "VTK      :\t ${VTK_VERSION} install to ${VTK_INSTALL_PREFIX}"

read -r -p "Are you sure? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        docker build . -t ${ORG}/lbibcell:${BOOST_VERSION} \
            --build-arg BOOST_VERSION=${BOOST_VERSION} \
            --build-arg BOOST_INSTALL_PREFIX=${BOOST_INSTALL_PREFIX} \
            --build-arg VTK_VERSION=${VTK_VERSION} \
            --build-arg VTK_INSTALL_PREFIX=${VTK_INSTALL_PREFIX}
        ;;
    *)
        exit 1 || return 1
        ;;
esac
