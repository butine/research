#!/bin/bash

helpme()
{
  cat <<HELPMEHELPME
Syntax: sudo $0

Installs the stuff needed to get the VirtualBox Ubuntu (or other similar Linux
host) into good shape to run our development environment.

This script needs to run as root.

The current directory must be the dev-env project directory.

HELPMEHELPME
}

if [[ "$1" == "-?" || "$1" == "-h" || "$1" == "--help" ]] ; then
  helpme
  exit 1
fi


set -e
set -x

#cd /tmp
#ver=0.12.7 #Replace this with the latest version available
#wget -c http://nodejs.org/dist/v$ver/node-v$ver.tar.gz #This is to download the source code.
#tar -xzf node-v$ver.tar.gz
#rm node-v$ver.tar.gz
#cd node-v$ver
#./configure && make && sudo make install
#cd /tmp && rm -rf node-v$ver

NODE_VER=0.12.7
NODE_PACKAGE=node-v$NODE_VER-linux-x64.tar.gz
TEMP_DIR=/tmp
SRC_PATH=$TEMP_DIR/$NODE_PACKAGE

cd $TEMP_DIR
# First remove any prior packages downloaded in case of failure
rm -f node*.tar.gz
wget --quiet https://nodejs.org/dist/v$NODE_VER/$NODE_PACKAGE
cd /usr/local && sudo tar --strip-components 1 -xzf $SRC_PATH
#rm $SRC_PATH
