#!/bin/bash

# build image
docker build build-image -t debian-buildroot:latest

# create volume if it doesn't exist
#docker volume inspect buildroot-vol || docker volume create buildroot-vol
[ -d output ] || mkdir -m 777 output

# build system
docker run --name=rock64-image-builder -v "$(pwd)"/output:/home/builder/build debian-buildroot:latest

