#!/bin/sh
VER="4.7.0"
URL="https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-$VER.tar.xz"

wget "$URL"
tar -Jxvf  "iproute2-$VER.tar.xz"
mkdir -p ./root
DEST=$(realpath "./root")
cd "./iproute2-$VER"
sed -i 's/m_ipt.o//' tc/Makefile
make clean
make
make DESTDIR="$DEST" install
rm -rf "$DEST/usr/share/doc"
rm -rf "$DEST/usr/share/man"
