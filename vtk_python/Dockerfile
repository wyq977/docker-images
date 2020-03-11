FROM wyq977/vtk

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update -qq && apt-get install -qq -y \
    # python3.6
    python3.6 \
    python3.6-dev \
    python3-distutils \
    python3-pip \
	&& rm -rf /var/lib/apt/lists/*