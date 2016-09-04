#!/bin/sh
VER="1.2.8"
URL="http://zlib.net/zlib-$VER.tar.xz"
wget "$URL"
mkdir -p root
mkdir -p root/lib
mkdir -p root-dev
mkdir -p root-dev/include
mkdir -p root-dev/lib
tar -Jxvf "zlib-$VER.tar.xz"
cd "zlib-$VER"
./configure --64 --libdir=lib
CFLAGS="-O3 -march=x86-64" make
cp -P ./*.so* ../root/lib
cp ./*.h ../root-dev/include
cp -P ./*.a ../root-dev/lib
