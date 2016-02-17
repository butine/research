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

SRCROOT=$GOROOT
SRCPATH=$GOPATH

#ARCH=`uname -m | sed 's|i686|386|' | sed 's|x86_64|amd64|'`
ARCH=amd64
GO_VER=1.5.1

cd /tmp
rm -f go$GO_VER.linux-${ARCH}.tar.gz
wget --quiet --no-check-certificate https://storage.googleapis.com/golang/go$GO_VER.linux-${ARCH}.tar.gz
tar -xvf go$GO_VER.linux-${ARCH}.tar.gz
sudo mv go $SRCROOT
sudo chmod 775 $SRCROOT
sudo chown -R vagrant:vagrant $SRCROOT
rm go$GO_VER.linux-${ARCH}.tar.gz
