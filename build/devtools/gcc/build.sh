#!/bin/sh
VER="6.2.0"
URL="https://ftp.gnu.org/gnu/gcc/gcc-$VER/gcc-$VER.tar.bz2"
#wget "$URL"
#tar -jxvf "gcc-$VER.tar.bz2"
mkdir -p root
DEST=$(realpath "./root")
GMP_INC=$(realpath "../gmp/root/usr/include")
GMP_LIB=$(realpath "../gmp/root/usr/lib")
MPFR_INC=$(realpath "../mpfr/root/usr/include")
MPFR_LIB=$(realpath "../mpfr/root/usr/lib")
MPC_INC=$(realpath "../mpc/root/usr/include")
MPC_LIB=$(realpath "../mpc/root/usr/lib")
cd "gcc-$VER"
make clean
CFLAGS="-O2 -march=x86-64" ./configure --prefix=/usr --disable-multilib --enable-ld=yes --enable-libada --enable-libssp --enable-lto --enable-languages=c,c++ --with-mpfr-include="$MPFR_INC" --with-mpfr-lib="$MPFR_LIB" --with-gmp-include="$GMP_INC" --with-gmp-lib="$GMP_LIB" --with-mpc-include="$MPC_INC" --with-mpc-lib="$MPC_LIB"
CFLAGS="-O2 -march=x86-64" make
make DESTDIR="$DEST" install
cd ../root/usr/bin
ln -s gcc cc
cd ../lib64
ln -s "../libexec/gcc/x86_64-pc-linux-gnu/$VER/liblto_plugin.so" liblto_plugin.so
cd ../../
