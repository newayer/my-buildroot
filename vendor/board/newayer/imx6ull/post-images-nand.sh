#!/bin/sh

rm -fr $BINARIES_DIR/rootfs.img && mv $BINARIES_DIR/rootfs.ubi $BINARIES_DIR/rootfs.img
rm -fr $BINARIES_DIR/rootfs.ubifs

./support/scripts/genimage.sh -c vendor/board/newayer/imx6ull/genimage_nand.cfg