#!/bin/bash

set -e

[ ! -e release ] && mkdir release
cd buildroot/output/images

BOARD=$(awk -F '=' '/BR2_GLOBAL_PATCH_DIR/ {split($2,a,"/"); printf("%s-%s"),a[3],a[4]}' < ../../.config)

sha256sum u-boot-tpl-spl.img u-boot.itb bootfs.ext4 rootfs.squashfs > checksum.sha256
tar -czpf ../../../release/rockos-${BOARD}-$(cat version.txt).tar.gz u-boot-tpl-spl.img u-boot.itb bootfs.ext4 rootfs.squashfs checksum.sha256
sha256sum ../../../release/rockos-${BOARD}-$(cat version.txt).tar.gz > ../../../release/rockos-${BOARD}-$(cat version.txt).tar.gz.sha256
rm checksum.sha256
cat sdcard.img | gzip > ../../../release/rockos-${BOARD}-$(cat version.txt).sdimage.gz
sha256sum ../../../release/rockos-${BOARD}-$(cat version.txt).sdimage.gz > ../../../release/rockos-${BOARD}-$(cat version.txt).sdimage.gz.sha256

cd -

python3 -m http.server 8080 -d release/
