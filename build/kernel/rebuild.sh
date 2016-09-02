#/bin/sh
KERNEL_VER="4.8-rc4"

cd "./kernel-src/linux-$KERNEL_VER"

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
rm "../../kernel-modules/lib/modules/$KERNEL_VER/build"
rm "../../kernel-modules/lib/modules/$KERNEL_VER/source"
../../../../bin/dir2sb ../../kernel-modules "../../02-kernel-modules-$KERNEL_VER.sb"

#make kernel headers
mkdir -p ../../kernel-headers/usr
make headers_install ARCH=x86_64 INSTALL_HDR_PATH=../../kernel-headers/usr
../../../../bin/dir2sb ../../kernel-headers "../../03-kernel-headers-$KERNEL_VER.sb"

#package the kernel source
cd ../../
mkdir -p "./kernel-src-tree/usr/src/linux-$KERNEL_VER"
cd "./kernel-src/linux-$KERNEL_VER"
cp -rf ./ "../../kernel-src-tree/usr/src/linux-$KERNEL_VER"
cd ../../kernel-src-tree/usr/src
ln -s "./linux-$KERNEL_VER" ./linux
cd linux
make clean
cd ../../../../
mkdir -p "./kernel-src-tree/lib/modules/$KERNEL_VER"
cd "./kernel-src-tree/lib/modules/$KERNEL_VER"
ln -s ../../../usr/src/linux ./source
ln -s ../../../usr/src/linux ./build
cd "../../../../kernel-src/linux-$KERNEL_VER"
../../../../bin/dir2sb ../../kernel-src-tree "../../07-kernel-sources-$KERNEL_VER.sb"

