#!/bin/sh
LFS="/mnt/lfs"
PKG_URL="http://files.etherlink.co/mirror"
LC_ALL=POSIX
LFS_TGT=$(uname -m)-artos-linux
export PATH=/tools/bin:$PATH
export LC_ALL LFS_TGT
