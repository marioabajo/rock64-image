#!/bin/bash

# build image
docker build build-image -t debian-buildroot:latest

# create volume if it doesn't exist
#docker volume inspect buildroot-vol || docker volume create buildroot-vol
[ -d output ] || mkdir output

# build system
docker run --name=rock64-image-builder --mount type=bind,source="$(pwd)"/output,target=/home/build/buildroot debian-buildroot:latest

