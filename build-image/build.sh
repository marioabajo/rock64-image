#!/bin/bash
set -e

# If buildroot version is not set, default to this one:
[ -z $VERS ] && VERS=2021.02.3

# If no build command is supplied, default to build everything:
[ -z $RUNCMD ] && RUNCMD="make"

# Deploy buildroot framework
if [ ! -e buildroot/Makefile ]; then
  wget https://buildroot.org/downloads/buildroot-"$VERS".tar.gz; \
  tar -zxpvf buildroot-"$VERS".tar.gz; \
  cp -a buildroot-"$VERS"/. buildroot
  rm -rf buildroot-"$VERS"
fi

if [ "$UPDATE_CONFIG" == 1 ] || [ ! -e "buildroot/.git_clone" ]; then
	git clone https://github.com/marioabajo/rock64-image
	git checkout master
	git pull
	touch buildroot/.git_clone
fi

# Generate the toolchain
if [ ! -e "buildroot/.toolchain-rockore" ]; then
	echo "###### Generating Toolchain..."
	cp -av rock64-image/build-image/buildroot/buildroot-toolchain.config buildroot/.config
	cd buildroot
	make oldconfig
	make source
	make toolchain

	echo "###### Toolchain generated, copying...."
	TOOLCHAIN_NAME="toolchain-rockore-$(date +%Y%m%d%H%M).tar.gz"
	cd output/host
	tar -czpf "$TOOLCHAIN_NAME" .
	cp "$TOOLCHAIN_NAME" ../
	cd ../../
	mkdir toolchain-rockore
	cp -a output/host/. toolchain-rockore

	echo "###### Cleaning buildroot environment..."
	make clean
	cd ..
	touch buildroot/.toolchain-rockore
fi

# Download from repository the latest configuration and patches
if [ ! -e "buildroot/.buildroot_board_env" ]; then
	echo "###### Setting up buildroot environment..."
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

# Start the board build process
if [ -e "buildroot/.buildroot_board_env" ]; then
	echo "##### Board image building..."
	cd buildroot
	make oldconfig
	make source
	$RUNCMD
fi
