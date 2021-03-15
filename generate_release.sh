#!/bin/bash

set -e

[ ! -e release ] && mkdir release
pv output/output/images/rootfs.ext4 | gzip > release/rock64-system-image-latest.img.gz
cd release
sha256sum rock64-system-image-latest.img.gz > rock64-system-image-latest.img.gz.sha256
cd ..

