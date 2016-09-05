#!/bin/sh
VER="2.69"
URL="https://ftp.gnu.org/gnu/autoconf/autoconf-$VER.tar.xz"

wget "$URL"
tar -Jxvf "autoconf-$VER.tar.xz"

mkdir -p root
DEST=$(realpath "./root")

cd "autoconf-$VER"
CFLAGS="-O2 -march=x86-64" ./configure --prefix=/usr
CFLAGS="-O2 -march=x86-64" make
make DESTDIR="$DEST" install
cd ../root
rm -rf ./usr/share/man
rm -rf ./usr/share/info
