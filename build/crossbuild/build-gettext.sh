#!/bin/sh
PKG="gettext"
PKG_BUILD="gettext"
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

EMACS="no" ../../extracts/$PKG/gettext-tools/configure --prefix=/tools            \
	     --disable-shared

echo "compiling $PKG_BUILD"
make -C gnulib-lib
make -C intl pluralx.c
make -C src msgfmt
make -C src msgmerge
make -C src xgettext

echo "installing $PKG_BUILD"
cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
