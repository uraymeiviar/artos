#!/bin/sh
VER="1.1.0"
URL="https://www.openssl.org/source/openssl-$VER.tar.gz"
wget "$URL"
mkdir -p root
mkdir -p root/lib
mkdir -p root/usr/bin
mkdir -p root-dev
mkdir -p root-dev/lib
mkdir -p root-dev/include
tar -zxvf "openssl-$VER.tar.gz"
cd "openssl-$VER"
./config --openssldir=/etc/ssl --libdir=lib shared zlib-dynamic
make depend
make
cp -rf ./include/openssl ../root-dev/include
cp ./libssl.a ../root-dev/lib
cp ./libssl.so.1.1 ../root/lib
cp ./libcrypto.a ../root-dev/lib
cp ./libcrypto.so.1.1 ../root/lib
cp ./apps/openssl ../root/usr/bin
cd ../root/lib
ln -s libssl.so.1.1 libssl.so.1
ln -s libssl.so.1 libssl.so
ln -s libcrypto.so.1.1 libcrypto.so.1
ln -s libcrypto.so.1 libcrypto.so
cd ../../

