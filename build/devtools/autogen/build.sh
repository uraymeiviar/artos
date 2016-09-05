#!/bin/sh
VER="5.18.7"
URL="https://ftp.gnu.org/gnu/autogen/autogen-$VER.tar.xz"

wget "$URL"
tar -Jxvf "autogen-$VER.tar.xz"

mkdir -p root
DEST=$(realpath "./root")

cd "autogen-$VER"
CFLAGS="-O2 -march=x86-64" ./configure --prefix=/usr
CFLAGS="-O2 -march=x86-64" make
make DESTDIR="$DEST" install
cd ../root
rm -rf ./usr/share/man
rm -rf ./usr/share/info
