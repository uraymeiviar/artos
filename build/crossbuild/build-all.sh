#!/bin/sh
rm -rf ./builds/*
rm -rf ./tools/*
./init.sh
./build-binutils-pass1.sh
./build-gcc-pass1.sh
./build-linuxheaders.sh
./build-glibc.sh
