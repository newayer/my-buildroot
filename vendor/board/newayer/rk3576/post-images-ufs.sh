#!/bin/sh

rm -fr $BINARIES_DIR/rootfs.img && mv $BINARIES_DIR/rootfs.ubi $BINARIES_DIR/rootfs.img
rm -fr $BINARIES_DIR/rootfs.ubifs

cp vendor/board/newayer/rk3576/parameter_ufs.txt $BINARIES_DIR/parameter.txt

./vendor/board/newayer/rk3576/mk-updateimg.sh
