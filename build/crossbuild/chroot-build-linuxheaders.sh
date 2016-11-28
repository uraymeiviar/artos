#!/bin/sh
PKG="linux"
PKG_BUILD="chroot-linux-headers"
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

cd ../extracts/$PKG
make mrproper

echo "installing $PKG_BUILD"
make INSTALL_HDR_PATH=../../builds/$PKG_BUILD headers_install
cd ../..
find ./builds/$PKG_BUILD/include \( -name .install -o -name ..install.cmd \) -delete
cp -rv ./builds/$PKG_BUILD/include/* /usr/include

