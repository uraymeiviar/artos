#!/bin/sh
PKG=""
if [ -z "$1" ]; then
	echo "usage : $0 [PKG-Name] <PKG-Build-Name>"
else
	PKG=$1
	source ./config.sh

	if [[ `wget -S --spider $PKG_URL/$PKG/$PKG-latest.txz 2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then 
		echo "retrieving $PKG from $PKG_URL"

    	#download compressed package if not exists
    	if [ ! -f ./sources/$PKG.txz ]; then
        	wget $PKG_URL/$PKG/$PKG-latest.txz -O ./sources/$PKG.txz
    	else
        	echo "sources/$PKG.txz already exists"
    	fi

        #download compressed package patches if not exist
        if [ ! -f ./sources/$PKG-patches.txz ]; then
            wget $PKG_URL/$PKG/$PKG-latest-patches.txz -O ./sources/$PKG-patches.txz
        else
            echo "sources/$PKG-patches.txz already exists"
        fi

        #if patches exists, extract it
        if [ -f ./sources/$PKG-patches.txz ]; then
            if [ ! -d ./extracts/$PKG-patches ]; then
                    dirname=`tar -tf ./sources/$PKG-patches.txz | head -1 | cut -f1 -d"/"`
                    cd ./extracts
                    echo "extracting $PKG-patches"
                    tar -xf ../sources/$PKG-patches.txz
                    mv $dirname $PKG-patches
                    cd ..
            else
                    echo "extracts/$PKG-patches already exists, skipping patch extraction"
            fi
        else
            echo "sources/$PKG-patches.txz does not exist, skipping patch"
        fi

        #extract compressed package
        if [ ! -d ./extracts/$PKG ]; then
            dirname=`tar -tf ./sources/$PKG.txz | head -1 | cut -f1 -d"/"`
            cd ./extracts
			echo "extracting $PKG"
            tar -xf ../sources/$PKG.txz
            mv $dirname $PKG
            #if patches available, apply it
            if [ -d $PKG-patches ]; then
                echo "applying patches"
                cd $PKG
                find ../$PKG-patches -name '*.patch' | while read line; do
                        echo "Processing file '$patch'"
                        patch -Np1 -i $line
                done
                cd ..
            fi
            cd ..
			echo "done. $PKG extracted to extracts/$PKG"
        else
            echo "extracts/$PKG already exist, skipping $PKG extraction"
        fi
	else
		echo "failed to get sources/$PKG.txz from $PKG_URL/$PKG/$PKG-latest.txz"
	fi
fi
