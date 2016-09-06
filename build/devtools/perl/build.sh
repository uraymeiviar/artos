#!/bin/sh
APP="perl"
VER="5.24.0"
EXT="tar.gz"
URL="http://www.cpan.org/src/5.0/$APP-$VER.$EXT"

if [ ! -f "./$APP-$VER.$EXT" ]; then
	wget "$URL"
fi

if [ ! -d "./$APP-$VER" ]; then
	if [ "$EXT" = "tar.xz" ]; then
		tar -Jxvf "$APP-$VER.$EXT"
	elif [ "$EXT" = "tar.bz2" ]; then
		tar -jxvf "$APP-$VER.$EXT"
	elif [ "$EXT" = "tar.gz" ]; then
		tar -zxvf "$APP-$VER.$EXT"
	fi
fi

mkdir -p root
DEST=$(realpath "./root")

cd "$APP-$VER"
make clean
CFLAGS="-O2 -march=x86-64" ./Configure -des -Dprefix=/usr -Dvendorperfix=/usr -Dpager="/usr/bin/less -isR" -Duseshrplib
CFLAGS="-O2 -march=x86-64" make
make DESTDIR="$DEST" install
cd ../root
rm -rf ./usr/share/man
rm -rf ./usr/share/doc
rm -rf ./usr/share/info
rm -rf ./usr/share/locale
