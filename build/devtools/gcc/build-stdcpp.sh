#!/bin/sh
VER="6.2.0"
mkdir -p stdc-root
STDDEST=$(realpath "./stdc-root")
GCCDEST=$(realpath "./root")
INC=$(realpath "./root/usr/include/c++/$VER")
cd "gcc-$VER"
make clean
make distclean
mkdir -p build
cd build
make clean
CFLAGS="-O2 -march=x86-64" ../libstdc++-v3/configure --prefix=/usr --enable-shared --enable-static --enable-libstdcxx-pch --disable-nls --enable-c99 --enable-libstdcxx-threads --enable-libstdcxx-filesystem-ts --disable-multilib --enable-cxx-flags="-O2 -march=x86-64"
CFLAGS="-O2 -march=x86-64" make
make DESTDIR="$STDDEST" install
cd ../../
