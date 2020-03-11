# docker_images

![](https://github.com/wyq977/docker_images/workflows/vtk/badge.svg)
![](https://github.com/wyq977/docker_images/workflows/vtk_python/badge.svg)


Automated build pipeline for Docker images

This should auto build and deploy images using github action.

## Set CI workflow on changed files

https://github.community/t5/GitHub-Actions/Trigger-a-workflow-on-change-to-the-yml-file-itself/m-p/49255

## Docker container FAQ

Some notes for containers:
https://brainlife.io/docs/apps/container/

1. Link lib when building images

https://github.com/CogChameleon/ChromaTag/issues/2

```bash
# linked lib properly
RUN ldconfig -v
```

2. Suppress warning
```bash
# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# change in the end
ENV DEBIAN_FRONTEND=dialog
```
This could also be done via
```bash
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update -qq && apt-get install -qq -y \
```

3. Change to `/bin/bash` in ubuntu build
```bash
#https://wiki.ubuntu.com/DashAsBinSh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
```

4. Remove and clean `apt-get` cache
```bash
RUN rm -rf /var/lib/apt/lists/*
```

## 1. `vtk` and `vtk_python` Docker

### Problem when trying to build vtk from source

Build guide (official): https://gitlab.kitware.com/vtk/vtk/blob/master/Documentation/dev/build.md
Build guide (official): https://vtk.org/Wiki/VTK/Building/Linux
Example (vtk 8.1.2): https://github.com/wowa/vtk-docker/blob/master/Dockerfile

### To use it with python vtk wrapper (not needed)

```bash
# To avoid "ModuleNotFoundError: No module named 'vtkOpenGLKitPython' " when importing vtk
# https://stackoverflow.com/q/32389599
# https://askubuntu.com/q/629692
# https://docs.pyvista.org/getting-started/installation.html
apt update && apt install python-qt4 libgl1-mesa-glx
apt update && apt install python-qt5
```