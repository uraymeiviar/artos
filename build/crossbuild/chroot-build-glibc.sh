#!/bin/sh
PKG="glibc"
PKG_BUILD="chroot-glibc"
source ./config.sh

if [ -d ./extracts/$PKG ]; then
	cd ./builds
	mkdir -p ./$PKG_BUILD
	cd ./$PKG_BUILD

	../../extracts/$PKG/configure --prefix=/usr              \
     			--enable-kernel=2.6.32             \
				--enable-obsolete-rpc

	echo "compiling $PKG_BUILD"
	make

	echo "installing $PKG_BUILD"
	touch /etc/ld.so.conf
	make install
	cp -v ../../extracts/$PKG/nscd/nscd.conf /etc/nscd.conf
	mkdir -pv /var/cache/nscd
	mkdir -pv /usr/lib/locale
	localedef -i en_US -f ISO-8859-1 en_US

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib
EOF

cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf
EOF

	mkdir -pv /etc/ld.so.conf.d
fi
