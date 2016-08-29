#!/bin/sh
VER="4.4-rc2"
URL="http://ftp.gnu.org/gnu/bash/bash-$VER.tar.gz"
wget "$URL"
tar -zxvf "bash-$VER.tar.gz"
mkdir -p root
DEST=$(realpath "./root")
mkdir -p build
cd build
make clean
CFLAGS="-O2 -march=x86-64" "../bash-$VER/configure" --prefix="$DEST" --enable-alias --enable-arith-for-command --enable-array-variables --enable-bang-history --enable-brace-expansion --enable-casemod-attributes --enable-casemod-expansions --enable-cond-command --enable-cond-regexp --enable-coprocesses --enable-debugger --enable-directory-stack --enable-history --enable-job-control --enable-multibyte --enable-process-substitution --enable-progcomp --enable-prompt-string-decoding --enable-readline --enable-restricted --enable-select --disable-nls --enable-extended-glob
make
make install
cd ../root
rm -rf ./lib/pkgconfig
rm -rf ./share
