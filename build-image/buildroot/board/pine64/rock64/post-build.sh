#!/bin/sh

MKIMAGE=$HOST_DIR/bin/mkimage
BOARD_DIR="$(dirname $0)"

$MKIMAGE -n rk3328 -T rksd -d $BINARIES_DIR/u-boot-tpl.bin $BINARIES_DIR/u-boot-tpl.img
cat $BINARIES_DIR/u-boot-tpl.img $BINARIES_DIR/u-boot-spl.bin > $BINARIES_DIR/u-boot-tpl-spl.img

install -m 0644 -D $BOARD_DIR/extlinux.conf $TARGET_DIR/boot/extlinux/extlinux.conf

grep -q "^/dev/disk/by-label/overlayfs /media/overlayfs" $TARGET_DIR/etc/fstab || \
echo "/dev/disk/by-label/overlayfs /media/overlayfs   ext4    auto,nofail     0       0" >> $TARGET_DIR/etc/fstab
grep -q "^none /etc  overlay" $TARGET_DIR/etc/fstab || \
echo "none /etc  overlay defaults,nofail,lowerdir=/etc,workdir=/media/overlayfs/workdir/etc,upperdir=/media/overlayfs/etc     0       0" >> $TARGET_DIR/etc/fstab
grep -q "^none /root overlay" $TARGET_DIR/etc/fstab || \
echo "none /root overlay defaults,nofail,lowerdir=/root,workdir=/media/overlayfs/workdir/root,upperdir=/media/overlayfs/root  0       0" >> $TARGET_DIR/etc/fstab
grep -q "^none /home overlay" $TARGET_DIR/etc/fstab || \
echo "none /home overlay defaults,nofail,lowerdir=/home,workdir=/media/overlayfs/workdir/home,upperdir=/media/overlayfs/home  0       0" >> $TARGET_DIR/etc/fstab
