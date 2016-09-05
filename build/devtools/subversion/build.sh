#!/bin/sh
APP="subversion"
VER="1.9.4"
EXT="tar.bz2"
URL="http://www.apache.org/dist/$APP/$APP-$VER.$EXT"

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
	cd "./$APP-$VER"
	patch -p1 < "../$APP.patch"
	cd ..
fi

if [ ! -f "./sqlite-amalgamation.zip" ]; then
	wget https://www.sqlite.org/2016/sqlite-amalgamation-3140100.zip -O ./sqlite-amalgamation.zip
	unzip sqlite-amalgamation.zip
	mv ./sqlite-amalgamation-3140100 "./$APP-$VER/sqlite-amalgamation"
fi
mkdir -p root
DEST=$(realpath "./root")
APRDIR=$(realpath "../apr/root/usr")
APRUTILDIR=$(realpath "../apr-util/root/usr")
EXPATDIR=$(realpath "../expat/root/usr")
cp -f "$APRUTILDIR/include/apr-1/apr_md5.h" "$APRDIR/include/apr-1/"
cd "$APP-$VER"
make clean
make distclean
CFLAGS="-O2 -march=x86-64" ./configure --prefix=/usr --disable-nls --with-apr="$APRDIR" --with-apr-util="$APRUTILDIR" --with-expat="$EXPATDIR/include:$EXPATDIR/lib/:$EXPATDIR/lib/"
CFLAGS="-O2 -march=x86-64" make
make DESTDIR="$DEST" install
cd ../root
rm -rf ./usr/share/man
rm -rf ./usr/share/doc
rm -rf ./usr/share/info
rm -rf ./usr/share/locale
