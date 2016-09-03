#!/bin/sh
VER="7.3p1"
URL="http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-$VER.tar.gz"
wget "$URL"
tar -zxvf "openssh-$VER.tar.gz"
mkdir -p ./root
DEST=$(realpath "./root")
mkdir -p ./build
cd build
CFLAGS="-O2 -march=x86-64" "../openssh-$VER/configure" --prefix="$DEST" --with-cflags="-O2 -march=x86-64"
CFLAGS="-O2 -march=x86-64" make
make install
cd ../root
rm -rf ./share
mkdir -p ./etc/ssh
mv ./etc/* ./etc/ssh
cp -rf ../pre-root/* ./
cd ..


