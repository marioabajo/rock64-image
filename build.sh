#!/bin/bash
set -e

# Deploy buildroot framework
if [ ! -e buildroot-"$VERS".tar.gz ]; then
	wget https://buildroot.org/downloads/buildroot-"$VERS".tar.gz;
fi
if [ ! -e buildroot/Makefile ]; then
	tar -zxpvf buildroot-"$VERS".tar.gz;
	ln -s buildroot-"$VERS" buildroot
fi

# Generate the toolchain
if [ ! -e "buildroot/.toolchain-rockore" ]; then
	echo "###### Generating Toolchain..."
	cp -av rock64-image/buildroot-setup/buildroot-toolchain.config buildroot/.config
	cd buildroot
	make oldconfig
	make source
	make toolchain

	echo "###### Toolchain generated, copying...."
	TOOLCHAIN_NAME="toolchain-rockore-$(date +%Y%m%d%H%M).tar.gz"
	cd output/host
	tar -czpf ../"$TOOLCHAIN_NAME" .
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
	cp -av rock64-image/buildroot-setup/. buildroot
	cp -av rock64-image/buildroot-setup/buildroot.config buildroot/.config
	if [ -e buildroot/patches ] && [ ! -e buildroot/patches/.applied ]; then
		cd buildroot
		for p in patches/*; do
			patch -p1 < "$p"
		done && touch patches/.applied
		cd ..
	fi
	rm -rf rock64-image
	touch buildroot/.buildroot_board_env
fi

# Start the board build process
if [ -e "buildroot/.buildroot_board_env" ]; then
	echo "##### Board image building..."
	cd buildroot
	make oldconfig
	make source
	$RUNCMD
fi

