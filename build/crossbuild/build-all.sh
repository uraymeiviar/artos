#!/bin/sh
rm -rf ./builds/*
rm -rf ./tools/*
./init.sh
./build-binutils-pass1.sh
./build-gcc-pass1.sh
./build-linuxheaders.sh
./build-glibc.sh
./build-binutils-pass2.sh
./build-gcc-pass2.sh
./build-check.sh
./build-ncurses.sh
./build-bash.sh
./build-bzip2.sh
./build-coreutils.sh
./build-diffutils.sh
./build-file.sh
./build-findutils.sh
./build-gawk.sh
