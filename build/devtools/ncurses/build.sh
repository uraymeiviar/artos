#!/bin/sh
APP="ncurses"
VER="6.0"
EXT="tar.gz"
URL="https://ftp.gnu.org/gnu/$APP/$APP-$VER.$EXT"

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
make distclean
export CPPFLAGS="-P"
CFLAGS="-O2 -march=x86-64" CPPFLAGS="-P" ./configure --prefix=/usr --disable-nls --with-shared --without-debug --enable-widec --with-cxx-shared --enable-sp-funcs --enable-term-driver --enable-ext-colors --enable-ext-mouse --enable-ext-putwin --with-gpm
CFLAGS="-O2 -march=x86-64" CPPFLAGS="-P" make
make DESTDIR="$DEST" install
cd ../root
rm -rf ./usr/share/man
rm -rf ./usr/share/doc
rm -rf ./usr/share/info
rm -rf ./usr/share/locale
