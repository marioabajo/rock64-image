#!/bin/bash

set -e

[ ! -e release ] && mkdir release
VERSION="$(cat output/output/images/version.txt)"
pv output/output/images/rootfs.squashfs | gzip > release/rock64-system-image-$VERSION.img.gz
ln -s -f rock64-system-image-$VERSION.img.gz release/rock64-system-image-latest.img.gz
cd release
sha256sum rock64-system-image-$VERSION.img.gz > rock64-system-image-$VERSION.img.gz.sha256
cd ..
ln -s -f rock64-system-image-$VERSION.img.gz.sha256 release/rock64-system-image-latest.img.gz.sha256

