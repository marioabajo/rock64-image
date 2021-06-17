#!/bin/sh

MKIMAGE=$HOST_DIR/bin/mkimage
BOARD_DIR="$(dirname $0)"
VERSION=0.5
BUILD_DATE=$(date +"%Y%m%d%H%M")


# Generate uboot TPL + SPL image
$MKIMAGE -n rk3328 -T rksd -d $BINARIES_DIR/u-boot-tpl.bin $BINARIES_DIR/u-boot-tpl.img
cat $BINARIES_DIR/u-boot-tpl.img $BINARIES_DIR/u-boot-spl.bin > $BINARIES_DIR/u-boot-tpl-spl.img

# Generate uboot main image
$MKIMAGE -A arm64 -O linux -T script -C none -a 0 -e 0 -n "boot script" -d $BOARD_DIR/boot.txt $TARGET_DIR/boot/boot.scr

# copy uboot boot script to system image
install -m 0644 -D $BOARD_DIR/boot.txt $TARGET_DIR/boot/boot.txt
# previous system # install -m 0644 -D $BOARD_DIR/extlinux.conf $TARGET_DIR/boot/extlinux/extlinux.conf

# add led modules to load at boot time
cat << EOF > $TARGET_DIR/etc/modules-load.d/led-trigger.conf
ledtrig-default-on
ledtrig-activity
ledtrig-heartbeat
ledtrig-netdev
EOF

# Generate the os-release file with information about the build date and version
echo "${VERSION}-${BUILD_DATE}" > $BINARIES_DIR/version.txt
cat << EOF > $TARGET_DIR/etc/os-release
NAME="Rockos"
ID="rockos"
ID_LIKE="buildroot"
VERSION="${VERSION}-${BUILD_DATE}"
VERSION_ID="${VERSION}-${BUILD_DATE}"
HOME_URL="https://github.com/marioabajo/rock64-image"
EOF

# Generate bootfs.ext4 image containing the kernel and device tree file
dd if=/dev/zero of=$BINARIES_DIR/bootfs.ext4 bs=1M count=100
mkfs.ext4 $BINARIES_DIR/bootfs.ext4
e2cp $BINARIES_DIR/Image $BINARIES_DIR/bootfs.ext4:
e2cp $BINARIES_DIR/rk3328-rock64.dtb $BINARIES_DIR/bootfs.ext4:

