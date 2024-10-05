#!/bin/sh

rm -fr $BINARIES_DIR/rootfs.img && ln -sf rootfs.ext2 $BINARIES_DIR/rootfs.img

dst=$BINARIES_DIR/rootfs.img

echo "resize2fs -M $dst"
resize2fs -M $dst
echo "e2fsck -fy  $dst"
e2fsck -fy  $dst
echo "tune2fs -m 5  $dst"
tune2fs -m 5  $dst
echo "resize2fs -M $dst"
resize2fs -M $dst