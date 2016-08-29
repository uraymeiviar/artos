#!/bin/sh
VER="8.25"
URL="http://ftp.gnu.org/gnu/coreutils/coreutils-$VER.tar.xz"
wget "$URL"
tar -Jxvf "coreutils-$VER.tar.xz"
mkdir -p ./root
DEST=$(realpath "./root")
cd "coreutils-$VER"
make clean
echo "destination = $DEST"
export FORCE_UNSAFE_CONFIGURE=1
CFLAGS="-O2 -march=x86-64" ./configure --prefix="$DEST" --enable-threads=posix --enable-single-binary=symlinks --disable-nls
CFLAGS="-O2 -march=x86-64" make
make install
rm -rf ../root/share
strip -s ../root/bin/coreutils
