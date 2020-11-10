#!/bin/bash

# Deploy buildroot framework
if [ ! -e buildroot/Makefile ]; then
  wget https://buildroot.org/downloads/buildroot-2020.05.tar.gz; \
  tar -zxpvf buildroot-2020.05.tar.gz; \
  mv buildroot-2020.05  buildroot
fi


# Download from repository the latest configuration and patches
if [ "$UPDATE_CONFIG" == 1 ]; then
	wget https://github.com/marioabajo/rock64-image/archive/main.zip
	unzip main.zip
	cp -av build-image/buildroot/* buildroot
	cp buildroot/buildroot.config buildroot/.config
fi


# Start the build process
cd buildroot
make oldconfig
make source
make
