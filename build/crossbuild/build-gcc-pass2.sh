#!/bin/sh
PKG="gcc"
PKG_BUILD="gcc-pass2"
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
        cd ../../
fi

cd ./extracts/$PKG

cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h

for file in \
 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
      -e 's@/usr@/tools@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

cd ../../

cd ./builds
mkdir -p ./$PKG_BUILD
cd ./$PKG_BUILD

CC=$LFS_TGT-gcc                                    \
CXX=$LFS_TGT-g++                                   \
AR=$LFS_TGT-ar                                     \
RANLIB=$LFS_TGT-ranlib                             \
../../extracts/$PKG/configure                      \
    --prefix=/tools                                \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --enable-languages=c,c++                       \
    --disable-libstdcxx-pch                        \
    --disable-multilib                             \
    --disable-bootstrap                            \
    --disable-libgomp

echo "compiling $PKG_BUILD"
make

echo "installing $PKG_BUILD"
make install
ln -sv gcc /tools/bin/cc

echo "testing $PKG_BUILD"
echo 'int main(){}' > gcc-phase2-test.c
cc gcc-phase2-test.c
readelf -l a.out | grep ': /tools'
rm -v gcc-phase2-test.c a.out
