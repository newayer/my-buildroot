#!/bin/sh

rm -fr $BINARIES_DIR/rootfs.img && mv $BINARIES_DIR/rootfs.ubi $BINARIES_DIR/rootfs.img
rm -fr $BINARIES_DIR/rootfs.ubifs
rm -fr $BINARIES_DIR/zImage

