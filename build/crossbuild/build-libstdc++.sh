#!/bin/sh
PKG="gcc"
PKG_BUILD="libstdc++"
source ./config.sh

if [ ! -f ./sources/$PKG.txz ]; then
	wget http://files.etherlink.co/mirror/$PKG/$PKG-latest.txz -O ./sources/$PKG.txz
fi

if [ ! -d ./extracts/$PKG ]; then
	dirname=`tar -tf ./sources/$PKG.txz | head -1 | cut -f1 -d"/"`
	cd ./extracts
	tar -xf ../sources/$PKG.txz
	mv $dirname $PKG
	cd ..
fi

cd ./builds
mkdir -p ./$PKG_BUILD
cd ./$PKG_BUILD

../../extracts/$PKG/libstdc++-v3/configure --prefix=/tools            \
    --host=$LFS_TGT                 \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-threads     \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/6.2.0

echo "compiling $PKG_BUILD"
make

echo "installing $PKG_BUILD"
make install
