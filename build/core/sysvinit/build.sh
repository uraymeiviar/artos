#!/bin/sh
VER="2.88dsf"
URL="http://download.savannah.gnu.org/releases/sysvinit/sysvinit-$VER.tar.bz2"
wget "$URL"
wget "http://ftp.lfs-matrix.net/pub/lfs/lfs-packages/7.6/sysvinit-$VER-consolidated-1.patch"
tar -jxvf "sysvinit-$VER.tar.bz2"
cd "sysvinit-$VER"
patch -p1 < "../sysvinit-$VER-consolidated-1.patch"
make clean
CFALGS="-O2 -march=x86-64" make
mkdir -p ../root/sbin
cp ./src/init ../root/sbin
cp ./src/halt ../root/sbin
cp ./src/shutdown ../root/sbin
cp ./src/runlevel ../root/sbin
cp ./src/killall5 ../root/sbin
cp ./src/fstab-decode ../root/sbin
cp ./src/bootlogd ../root/sbin
cd ../root/sbin
ln -s halt reboot
ln -s halt poweroff
ln -s init telinit
