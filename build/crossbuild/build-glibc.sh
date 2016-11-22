#!/bin/sh
PKG="glibc"
PKG_BUILD="glibc"
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

../../extracts/$PKG/configure --prefix=/tools              \
			--host=$LFS_TGT                    \
     			--build=$(../../extracts/$PKG/scripts/config.guess) \
     			--enable-kernel=2.6.32             \
      			--with-headers=/tools/include      \
      			libc_cv_forced_unwind=yes          \
      			libc_cv_c_cleanup=yes

echo "compiling $PKG_BUILD"
make

echo "installing $PKG_BUILD"
make install

echo "testing $PKG_BUILD"
echo 'int main(){}' > ./glibc-test.c
$LFS_TGT-gcc ./glibc-test.c
readelf -l a.out | grep ': /tools'
