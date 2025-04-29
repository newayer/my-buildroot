#!/bin/sh

TOP=`pwd`
RK_PACK_TOOL_DIR=$TOP/vendor/tools/Linux_Pack_Firmware

cp vendor/board/newayer/rk3506/package-file $BINARIES_DIR/package-file

cd $BINARIES_DIR/
TAG=RK$(hexdump -s 21 -n 4 -e '4 "%c"' MiniLoaderAll.bin | rev)
"$RK_PACK_TOOL_DIR/afptool" -pack ./ update.raw.img
"$RK_PACK_TOOL_DIR/rkImageMaker" -$TAG MiniLoaderAll.bin update.raw.img update.img -os_type:androidos
cd -

rm -fr $BINARIES_DIR/package-file $BINARIES_DIR/update.raw.img
