#!/bin/sh
PKG="bzip2"
PKG_BUILD="bzip2"
source ./config.sh

if [ ! -f ./sources/$PKG.txz ]; then
	wget http://files.etherlink.co/mirror/$PKG/$PKG-latest.txz -O ./sources/$PKG.txz
fi

if [ -d ./extracts/$PKG ]; then
	rm -rf ./extracts/$PKG
fi

if [ ! -d ./extracts/$PKG ]; then
	dirname=`tar -tf ./sources/$PKG.txz | head -1 | cut -f1 -d"/"`
	cd ./extracts
	tar -xf ../sources/$PKG.txz
	mv $dirname $PKG
	cd ..
fi

cd ./extracts/$PKG

echo "compiling $PKG_BUILD"
make

echo "installing $PKG_BUILD"
make PREFIX=/tools install
