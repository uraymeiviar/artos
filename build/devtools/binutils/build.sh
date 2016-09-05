#!/bin/sh
APP="binutils"
VER="2.27"
EXT="tar.bz2"
URL="https://ftp.gnu.org/gnu/$APP/$APP-$VER.$EXT"

if [ ! -f "./$APP-$VER.$EXT" ]; then
	wget "$URL"
fi

if [ ! -d "./$APP-$VER" ]; then
	if [ "$EXT" = "tar.xz" ]; then
		tar -Jxvf "$APP-$VER.$EXT"
	elif [ "$EXT" = "tar.bz2" ]; then
		tar -jxvf "$APP-$VER.$EXT"
	elif [ "$EXT" = "tar.gz" ]; then
		tar -zxvf "$APP-$VER.$EXT"
	fi
fi

mkdir -p root
DEST=$(realpath "./root")
GMP_INC=$(realpath "../gmp/root/usr/include")
GMP_LIB=$(realpath "../gmp/root/usr/lib")
MPFR_INC=$(realpath "../mpfr/root/usr/include")
MPFR_LIB=$(realpath "../mpfr/root/usr/lib")
MPC_INC=$(realpath "../mpc/root/usr/include")
MPC_LIB=$(realpath "../mpc/root/usr/lib")
cd "$APP-$VER"
make clean
CFLAGS="-O2 -march=x86-64" ./configure --prefix=/usr --enable-lto --enable-shared --disable-werror --disable-nls --with-mpfr-include="$MPFR_INC" --with-mpfr-lib="$MPFR_LIB" --with-gmp-include="$GMP_INC" --with-gmp-lib="$GMP_LIB" --with-mpc-include="$MPC_INC" --with-mpc-lib="$MPC_LIB"
CFLAGS="-O2 -march=x86-64" make
make DESTDIR="$DEST" tooldir=/usr install
cd ../root
rm -rf ./usr/share/man
rm -rf ./usr/share/doc
rm -rf ./usr/share/info
