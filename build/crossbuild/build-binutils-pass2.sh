#!/bin/sh
PKG="binutils"
PKG_BUILD="binutils-pass2"
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

CC=$LFS_TGT-gcc                \
AR=$LFS_TGT-ar                 \
RANLIB=$LFS_TGT-ranlib         \
../../extracts/$PKG/configure --prefix=/tools            \
    --disable-nls              \
    --disable-werror           \
    --with-lib-path=/tools/lib \
    --with-sysroot

echo "compiling $PKG_BUILD"
make

echo "installing $PKG_BUILD"
make install

echo "re-adjusting toolchain"
make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new /tools/bin
