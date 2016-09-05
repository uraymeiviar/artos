#!/bin/sh
APP="gc"
VER="7.6.0"
EXT="tar.gz"
URL="http://www.hboehm.info/gc/gc_source/$APP-$VER.$EXT"

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
CFLAGS="-O2 -march=x86-64" ./configure --prefix=/usr --disable-nls
CFLAGS="-O2 -march=x86-64" make
make DESTDIR="$DEST" install
cd ../root
rm -rf ./usr/share/man
rm -rf ./usr/share/doc
rm -rf ./usr/share/info
