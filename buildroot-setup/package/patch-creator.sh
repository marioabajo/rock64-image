#!/bin/bash

version=2021.08.1
PACKAGES="conmon podman containernetworking-plugins cri-tools crio libslirp slirp4netns libyajl crun shadow"

[ $# -ge 1 ] && PACKAGES=$@

cd ../../temp
# tar -zxpvf ...
cp -a buildroot-${version} buildroot-${version}-a
cp -a buildroot-${version} buildroot-${version}-b
num=10
for i in $PACKAGES
do
	cd buildroot-${version}-b
	cp -a ../../buildroot-setup/package/$i package/
	patch -p1 < ../../buildroot-setup/package/$i-config.patch
	rm -f package/Config.in.orig
	cd ..
	diff -uNr --no-dereference buildroot-${version}-a buildroot-${version}-b > ../buildroot-setup/patches/${num}-${i}.patch
	cd buildroot-${version}-a
	patch -p1 < ../../buildroot-setup/patches/${num}-${i}.patch
	cd ..
	num=$((num + 10))
done
rm -rf buildroot-${version}-a buildroot-${version}-b
