#!/bin/bash
set -e

# Deploy buildroot framework
if [ ! -e buildroot-"$VERS".tar.gz ]; then
	wget https://buildroot.org/downloads/buildroot-"$VERS".tar.gz;
fi
if [ ! -e buildroot/Makefile ]; then
	tar -zxpvf buildroot-"$VERS".tar.gz;
	ln -s buildroot-"$VERS" buildroot

	# Copy sources if backup exists
	if [ -d src-backup ]; then
		[ -d buildroot/dl ] || mkdir buildroot/dl
		cp -a src-backup/* buildroot/dl
	fi
fi

# Generate the toolchain
if [ ! -e ".toolchain-rockore" ]; then
	echo "###### Generating Toolchain..."
	cp -av rock64-image/buildroot-setup/buildroot-toolchain.config buildroot/.config
	cd buildroot
	make oldconfig
	make source
	make sdk

	echo "###### Toolchain generated, copying...."
	cp output/images/aarch64-rockore-linux-gnu_sdk-buildroot.tar.gz ../

	echo "###### Cleaning buildroot environment..."
	make clean
	cd ..
	touch .toolchain-rockore
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

