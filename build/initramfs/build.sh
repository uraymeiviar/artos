#!/bin/sh
BUSYBOX_VER="1.25.0"
BUSYBOX_DOWNLOAD_URL="https://busybox.net/downloads/busybox-$BUSYBOX_VER.tar.bz2"
wget "$BUSYBOX_DOWNLOAD_URL"
tar -jxvf "busybox-$BUSYBOX_VER.tar.bz2"
cd "busybox-$BUSYBOX_VER"
make clean
cp ../busybox.config ./.config
LDFLAGS=-static CFLAGS="-O2 -march=x86-64" make
make install
mkdir -p ../root
cp -rf ../rootfs/* ../root/
cp -rf ../livekit/* ../root/
cp -rf ./_install/* ../root/
../../bin/dir2initrfs ./root ./initrfs.img

