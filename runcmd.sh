#!/bin/bash

podman run -ti --userns keep-id --rm -v "$(pwd)":/home/builder/build -e RUNCMD="$*" debian-buildroot:latest
