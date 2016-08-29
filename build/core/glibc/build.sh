#!/bin/sh
VER="2.24"
URL="http://ftp.gnu.org/gnu/glibc/glibc-$VER.tar.xz"
wget "$URL"
tar -Jxvf "glibc-$VER.tar.xz"
mkdir -p ./root
DEST=$(realpath "./root")
echo "destination = $DEST"
mkdir -p build
cd "build"
CFLAGS="-O2 -march=x86-64" "../glibc-$VER/configure" --prefix="$DEST" --enable-shared
make
make install
