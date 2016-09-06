#!/bin/sh
VER="1.15"
URL="https://ftp.gnu.org/gnu/automake/automake-$VER.tar.xz"

wget "$URL"
tar -Jxvf "automake-$VER.tar.xz"

mkdir -p root
DEST=$(realpath "./root")

cd "automake-$VER"
CFLAGS="-O2 -march=x86-64" ./configure --prefix=/usr
CFLAGS="-O2 -march=x86-64" make
make DESTDIR="$DEST" install
cd ../root
rm -rf ./usr/share/man
rm -rf ./usr/share/info