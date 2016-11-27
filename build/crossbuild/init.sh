#!/bin/sh
source ./config.sh
mkdir -pv ./sources
chmod -v a+wt .sources
mkdir -pv $LFS/tools
mkdir -pv ./builds
mkdir -pv ./extracts
ln -sv $LFS/tools /
mkdir -pv /tools/lib
ln -sv lib /tools/lib64
echo "target = $LFS_TGT"
export PATH=/tools/bin:$PATH
echo $PATH
