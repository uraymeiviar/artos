#!/bin/sh
VER="2.24"
URL="http://ftp.gnu.org/gnu/glibc/glibc-$VER.tar.xz"
wget "$URL"
tar -Jxvf "glibc-$VER.tar.xz"
mkdir -p ./root
DEST=$(realpath "./root")
echo "destination = $DEST"
mkdir -p build
cd "build"
CFLAGS="-O3 -march=x86-64" "../glibc-$VER/configure" --prefix="" --enable-shared
make
make install install_root="$DEST"

cd ../root
rm -rf ./var
rm -rf ./share/locale/*

mkdir -p /tmp/glibc
cp ./share/i18n/charmaps/UTF-8.gz /tmp/glibc/
rm -f ./share/i18n/charmaps/*
mv /tmp/glibc/UTF-8.gz ./share/i18n/charmaps

cp ./share/i18n/locales/en_US /tmp/glibc
rm -f ./share/i18n/locales/*
mv /tmp/glibc/en_US ./share/i18n/locales/

mkdir -p ../root-dev
mv ./include ../root-dev

mkdir -p ../root-dev/lib
mv ./lib/*.a ../root-dev/lib
mv ./lib/*.o ../root-dev/lib

cp ./lib/gconv/UTF-* /tmp/glibc
cp ./lib/gconv/UNICODE.so /tmp/glibc
rm -rf ./lib/gconv/*
cp /tmp/glibc/* ./lib/gconv/

echo "include /etc/ld.so.conf.d/*.conf" > ./etc/ld.so.conf
rm ./etc/ld.so.cache
mkdir -p ./etc/ld.so.conf.d
echo "/lib" > ./etc/ld.so.conf.d/glibc.conf
echo "/usr/lib" >> ./etc/ld.so.conf.d/glibc.conf
echo "/usr/lib64" >> ./etc/ld.so.conf.d/glibc.conf
echo "/lib64" >>  ./etc/ld.so.conf.d/glibc.conf

