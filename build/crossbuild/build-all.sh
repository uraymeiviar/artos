#!/bin/sh
rm -rf ./builds/*
rm -rf ./tools/*
./build-binutils-pass1.sh
./build-gcc-pass1.sh
./build-linuxheaders.sh
./build-glibc.sh
