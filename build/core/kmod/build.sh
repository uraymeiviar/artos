#!/bin/sh
VER="23"
URL="https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-$VER.tar.xz"
wget "$URL"
tar -Jxvf "kmod-$VER.tar.xz"
mkdir -p root
DEST=$(realpath "./root")
mkdir -p build
cd build
make distclean
CFLAGS="-O2 -march=x86-64" "../kmod-$VER/configure" --prefix="$DEST" --enable-experimental --disable-manpages --disable-test-modules --with-xz --with-zlib
make
make install
rm -rf ../root/lib/pkgconfig
cd ../root/bin
ln -s kmod lsmod
ln -s kmod rmmod
ln -s kmod insmon
ln -s kmod modinfo
ln -s kmod modprobe
ln -s kmod depmod
