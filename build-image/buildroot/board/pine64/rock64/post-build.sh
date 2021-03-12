#!/bin/sh

MKIMAGE=$HOST_DIR/bin/mkimage
BOARD_DIR="$(dirname $0)"

$MKIMAGE -n rk3328 -T rksd -d $BINARIES_DIR/u-boot-tpl.bin $BINARIES_DIR/u-boot-tpl.img
cat $BINARIES_DIR/u-boot-tpl.img $BINARIES_DIR/u-boot-spl.bin > $BINARIES_DIR/u-boot-tpl-spl.img

# New boot system using boot script
$MKIMAGE -A arm64 -O linux -T script -C none -a 0 -e 0 -n "boot script" -d boot.txt boot.scr
install -m 0644 -D $BOARD_DIR/boot.scr $TARGET_DIR/boot/boot.scr
# previous system # install -m 0644 -D $BOARD_DIR/extlinux.conf $TARGET_DIR/boot/extlinux/extlinux.conf
