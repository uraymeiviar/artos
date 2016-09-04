#!/bin/sh
VER="1.0.3"
#URL="https://ftp.gnu.org/gnu/mpc/mpc-$VER.tar.gz"
#wget "$URL"
#tar -zxvf "mpc-$VER.tar.gz"
mkdir -p root
DEST=$(realpath "./root")
GMP_INC=$(realpath "../gmp/root/usr/include")
GMP_LIB=$(realpath "../gmp/root/usr/lib")
MPFR_INC=$(realpath "../mpfr/root/usr/include")
MPFR_LIB=$(realpath "../mpfr/root/usr/lib")
cd "mpc-$VER"
make clean
CFLAGS="-O2 -march=x86-64" ./configure --disable-static --prefix=/usr --with-mpfr-include="$MPFR_INC" --with-mpfr-lib="$MPFR_LIB" --with-gmp-include="$GMP_INC" --with-gmp-lib="$GMP_LIB"
CFLAGS="-O2 -march=x86-64" make
make DESTDIR="$DEST" install
rm -rf ../root/usr/share
