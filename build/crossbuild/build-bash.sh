#!/bin/sh
PKG="bash"
PKG_BUILD="bash"
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

../../extracts/$PKG/configure --prefix=/tools            \
	--without-bash-malloc

echo "compiling $PKG_BUILD"
make

echo "installing $PKG_BUILD"
make install
ln -sv bash /tools/bin/sh
