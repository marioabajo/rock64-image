#!/bin/bash

# Deploy buildroot framework
if [ ! -e buildroot/Makefile ]; then
  wget https://buildroot.org/downloads/buildroot-2020.05.tar.gz; \
  tar -zxpvf buildroot-2020.05.tar.gz; \
  cp -a buildroot-2020.05/. buildroot
  rm -rf buildroot-2020.05
fi


# Download from repository the latest configuration and patches
if [ "$UPDATE_CONFIG" == 1 ]; then
	git clone https://github.com/marioabajo/rock64-image
	cp -av rock64-image/build-image/buildroot/. buildroot
	cp -av rock64-image/build-image/buildroot/buildroot.config buildroot/.config
	rm -rf rock64-image
fi


# Start the build process
cd buildroot
make oldconfig
make source
make
