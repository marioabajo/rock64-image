#!/bin/bash

# build image
docker build build-image -t debian-buildroot:latest

# create volume if it doesn't exist
[ -d output ] || mkdir -m 777 output

# build system
docker run --name=rock64-image-builder -v "$(pwd)":/home/builder/build debian-buildroot:latest

