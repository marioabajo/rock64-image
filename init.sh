#!/bin/bash
set -e

# build image
podman build build-image -t debian-buildroot:latest

# create volume if it doesn't exist
[ -d output ] || mkdir -m 777 output

# build system
podman run --userns keep-id --name=rock64-image-builder -v "$(pwd)":/home/builder/build debian-buildroot:latest

