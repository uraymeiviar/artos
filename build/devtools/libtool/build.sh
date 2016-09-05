#!/bin/sh
VER="2.4.6"
URL="https://ftp.gnu.org/gnu/libtool/libtool-$VER.tar.xz"

wget "$URL"
tar -Jxvf "libtool-$VER.tar.xz"

mkdir -p root
DEST=$(realpath "./root")

cd "libtool-$VER"
CFLAGS="-O2 -march=x86-64" ./configure --prefix=/usr
CFLAGS="-O2 -march=x86-64" make
make DESTDIR="$DEST" install
cd ../root
rm -rf ./usr/share/man
rm -rf ./usr/share/info
