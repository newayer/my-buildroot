#!/bin/sh

rm -fr $BINARIES_DIR/rootfs.img && mv $BINARIES_DIR/rootfs.ext2 $BINARIES_DIR/rootfs.img
rm -fr $BINARIES_DIR/rootfs.ext4

dst=$BINARIES_DIR/rootfs.img

echo "resize2fs -M $dst"
resize2fs -M $dst
echo "e2fsck -fy  $dst"
e2fsck -fy  $dst
echo "tune2fs -m 5  $dst"
tune2fs -m 5  $dst
echo "resize2fs -M $dst"
resize2fs -M $dst

cp vendor/board/newayer/rk3576/parameter_emmc.txt $BINARIES_DIR/parameter.txt

./vendor/board/newayer/rk3576/mk-updateimg.sh
