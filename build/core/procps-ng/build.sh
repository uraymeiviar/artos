#!/bin/sh
VER="3.3.12"
URL="http://ncu.dl.sourceforge.net/project/procps-ng/Production/procps-ng-$VER.tar.xz"
wget "$URL"
tar -Jxvf "procps-ng-$VER.tar.xz"
mkdir -p root
DEST=$(realpath "./root")
mkdir -p build
cd build
make clean
CFLAGS="-O2 -march=x86-64" "../procps-ng-$VER/configure" --prefix="$DEST" --disable-nls --enable-skill --enable-sigwinch --enable-wide-percent
make
make install
rm -rf ../root/lib/pkgconfig
rm -rf ../root/share
