#!/bin/bash

# If buildroot version is not set, default to this one:
[ -z $VERS ] && VERS=2021.02.1

# If no build command is supplied, default to build everything:
[ -z $RUNCMD ] && RUNCMD="make"

# Deploy buildroot framework
if [ ! -e buildroot/Makefile ]; then
  wget https://buildroot.org/downloads/buildroot-"$VERS".tar.gz; \
  tar -zxpvf buildroot-"$VERS".tar.gz; \
  cp -a buildroot-"$VERS"/. buildroot
  rm -rf buildroot-"$VERS"
fi


# Download from repository the latest configuration and patches
if [ "$UPDATE_CONFIG" == 1 ] || [ ! -e buildroot/.config ]; then
	git clone https://github.com/marioabajo/rock64-image
	git checkout master
	git pull
	cp -av rock64-image/build-image/buildroot/. buildroot
	cp -av rock64-image/build-image/buildroot/buildroot.config buildroot/.config
	if [ -e buildroot/patches ] && [ ! -e buildroot/patches/.applied ]; then
		cd buildroot
		for p in patches/*; do
			patch -p1 < "$p"
		done && touch patches/.applied
		cd ..
	fi
	rm -rf rock64-image
fi


# Start the build process
cd buildroot
make oldconfig
make source
$RUNCMD
