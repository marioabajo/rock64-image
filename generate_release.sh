#!/bin/bash

set -e

[ ! -e release ] && mkdir release
cd buildroot/output/images

BOARD=$(awk -F '=' '/BR2_GLOBAL_PATCH_DIR/ {split($2,a,"/"); printf("%s-%s"),a[2],a[3]}' < ../../.config)

sha256sum u-boot-tpl-spl.img u-boot.itb bootfs.ext4 rootfs.squashfs > checksum.sha256
tar -czpf rockos-${BOARD}-$(cat version.txt).tar.gz u-boot-tpl-spl.img u-boot.itb bootfs.ext4 rootfs.squashfs checksum.sha256
sha256sum rockos-${BOARD}-$(cat version.txt).tar.gz > rockos-${BOARD}-$(cat version.txt).tar.gz.sha256
rm checksum.sha256
mv rockos-${BOARD}-$(cat version.txt).tar.gz ../../../release/
mv rockos-${BOARD}-$(cat version.txt).tar.gz.sha256 ../../../release/

cd -
