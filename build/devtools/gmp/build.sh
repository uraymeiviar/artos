#!/bin/sh
VER="6.1.1"
URL="https://gmplib.org/download/gmp/gmp-$VER.tar.xz"
mkdir root
DEST=$(realpath "./root")
wget "$URL"
tar -Jxvf "gmp-$VER.tar.xz"
cd "gmp-$VER"
make clean
CFLAGS="-O2 -march=x86-64" ./configure --prefix=/usr --disable-static --enable-cxx --enable-mpbsd
CFLAGS="-O2 -march=x86-64" make
make DESTDIR="$DEST" install
cd rm -rf ../root/usr/share
