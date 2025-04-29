#!/bin/sh

rm -fr $BINARIES_DIR/rootfs.img && mv $BINARIES_DIR/rootfs.ubi $BINARIES_DIR/rootfs.img
rm -fr $BINARIES_DIR/rootfs.ubifs
rm -fr $BINARIES_DIR/zImage

cp vendor/board/newayer/rk3506/parameter_nand.txt $BINARIES_DIR/parameter.txt

./vendor/board/newayer/rk3506/mk-updateimg.sh
