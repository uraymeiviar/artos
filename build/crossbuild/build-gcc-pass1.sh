#!/bin/sh
PKG="gcc"
PKG_BUILD="gcc-pass1"
source ./config.sh

if [ ! -f ./sources/$PKG.txz ]; then
	wget http://files.etherlink.co/mirror/$PKG/$PKG-latest.txz -O ./sources/$PKG.txz
fi

if [ ! -f ./sources/mpfr.txz ]; then
        wget http://files.etherlink.co/mirror/mpfr/mpfr-latest.txz -O ./sources/mpfr.txz
fi

if [ ! -f ./sources/mpc.txz ]; then
        wget http://files.etherlink.co/mirror/mpc/mpc-latest.txz -O ./sources/mpc.txz
fi

if [ ! -f ./sources/gmp.txz ]; then
        wget http://files.etherlink.co/mirror/gmp/gmp-latest.txz -O ./sources/gmp.txz
fi

if [ ! -d ./extracts/mpfr ]; then
        dirname=`tar -tf ./sources/mpfr.txz | head -1 | cut -f1 -d"/"`
        cd ./extracts
        tar -xf ../sources/mpfr.txz
        mv $dirname mpfr
        cd ..
fi

if [ ! -d ./extracts/mpc ]; then
        dirname=`tar -tf ./sources/mpc.txz | head -1 | cut -f1 -d"/"`
        cd ./extracts
        tar -xf ../sources/mpc.txz
        mv $dirname mpc
        cd ..
fi

if [ ! -d ./extracts/gmp ]; then
        dirname=`tar -tf ./sources/gmp.txz | head -1 | cut -f1 -d"/"`
        cd ./extracts
        tar -xf ../sources/gmp.txz
        mv $dirname gmp
        cd ..
fi

if [ ! -d ./extracts/$PKG ]; then
        dirname=`tar -tf ./sources/$PKG.txz | head -1 | cut -f1 -d"/"`
        cd ./extracts
        tar -xf ../sources/$PKG.txz
        mv $dirname $PKG
	cd $PKG
	ln -s ../mpfr mpfr
	ln -s ../mpc mpc
	ln -s ../gmp gmp
        cd ../..
fi

cd ./builds
mkdir -p ./$PKG_BUILD
cd ./$PKG_BUILD

../../extracts/$PKG/configure                      \
    --target=$LFS_TGT                              \
    --prefix=/tools                                \
    --with-glibc-version=2.11                      \
    --with-sysroot=$LFS                            \
    --with-newlib                                  \
    --without-headers                              \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --disable-nls                                  \
    --disable-shared                               \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libmpx                               \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++

echo "compiling $PKG_BUILD"
make

echo "installing $PKG_BUILD"
make install
