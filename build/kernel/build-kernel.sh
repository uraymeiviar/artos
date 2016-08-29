#!/bin/sh
KERNEL_VER="4.8-rc4"
#download kernel source
mkdir -p ./downloaded
wget "https://cdn.kernel.org/pub/linux/kernel/v4.x/testing/linux-$KERNEL_VER.tar.xz" -P ./downloaded/
#extract kernel source
mkdir -p ./kernel-src
tar -Jxvf "./downloaded/linux-$KERNEL_VER.tar.xz" -C ./kernel-src
#checkout aufs patch
git clone https://github.com/sfjro/aufs4-standalone.git
cd aufs4-standalone
git checkout origin/aufs4.x-rcN
#copy patch files
cp -rf ./Documentation ./fs "./../kernel-src/linux-$KERNEL_VER/"
cp ./include/uapi/linux/aufs_type.h "./../kernel-src/linux-$KERNEL_VER/include/uapi/linux/"
cd ..
#checkout aufs-util
git clone git://git.code.sf.net/p/aufs/aufs-util
cd aufs-util
git checkout origin/aufs4.x-rcN
cd ..
#patch the kernels
cd "./kernel-src/linux-$KERNEL_VER"
patch -p1 < ../../aufs4-standalone/aufs4-kbuild.patch
patch -p1 < ../../aufs4-standalone/aufs4-base.patch
patch -p1 < ../../aufs4-standalone/aufs4-mmap.patch
patch -p1 < ../../aufs4-standalone/aufs4-standalone.patch 
#build the kernel
make mrproper
cp ../../kernel-config ./.config
cp ../../kernel-config ./.config-x86_64
make -j8
cp arch/x86/boot/bzImage ../../vmlinuz
#make modules
mkdir -p ../../kernel-modules
make modules_install INSTALL_MOD_PATH=../../kernel-modules
make firmware_install INSTALL_MOD_PATH=../../kernel-modules
#make kernel headers
mkdir -p ../../kernel-headers
make headers_install ARCH=x86_64 INSTALL_HDR_PATH=../../kernel-headers
cd ../../kernel-headers
mkdir -p usr
mv ./include ./usr
cd ../
../../bin/dir2sb ./kernel-modules "./02-kernel-modules-$KERNEL_VER.sb"
../../bin/dir2sb ./kernel-headers "./03-kernel-headers-$KERNEL_VER.sb"
