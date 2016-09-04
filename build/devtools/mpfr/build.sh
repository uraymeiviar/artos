#!/bin/sh
VER="3.1.4"
URL="https://ftp.gnu.org/gnu/mpfr/mpfr-$VER.tar.xz"
mkdir -p root
DEST=$(realpath "./root")
wget "$URL"
tar -Jxvf "mpfr-$VER.tar.xz"
GMP_INC=$(realpath "../gmp/root/usr/include")
GMP_LIB=$(realpath "../gmp/root/usr/lib")
cd "mpfr-$VER"
make clean
CFLAGS="-O2 -march=x86-64"  ./configure --prefix=/usr --disable-static --enable-thread-safe --with-gmp-include="$GMP_INC" --with-gmp-lib="$GMP_LIB"
CFLAGS="-O2 -march=x86-64" make
make DESTDIR="$DEST" install
rm -rf ../root/usr/share
