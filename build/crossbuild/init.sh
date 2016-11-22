#!/bin/sh
source ./config.sh
mkdir -pv $LFS/sources
chmod -v a+wt $LFS/sources
mkdir -pv $LFS/tools
mkdir -pv $LFS/builds
mkdir -pv $LFS/extracts
ln -sv $LFS/tools /
mkdir -pv /tools/lib
ln -sv lib /tools/lib64
echo "target = $LFS_TGT"
export PATH=/tools/bin:$PATH
echo $PATH
