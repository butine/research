#!/bin/bash

helpme()
{
  cat <<HELPMEHELPME
Syntax: sudo $0

Installs the stuff needed to get the VirtualBox Ubuntu (or other similar Linux
host) into good shape to serve as the base vagrant "box" for our development environment.

This script needs to run as root.

The current directory must be the dev-env project directory.

HELPMEHELPME
}

if [[ "$1" == "-?" || "$1" == "-h" || "$1" == "--help" ]] ; then
  helpme
  exit 1
fi

# Installs the stuff needed to get the VirtualBox Ubuntu (or other similar Linux
# host) into good shape to run our development environment.

# ALERT: if you encounter an error like:
# error: [Errno 1] Operation not permitted: 'cf_update.egg-info/requires.txt'
# The proper fix is to remove any "root" owned directories under your update-cli directory
# as source mount-points only work for directories owned by the user running vagrant

# Stop on first error
set -e

# Update the entire system to the latest releases
apt-get update -qq

# install git
apt-get install --yes git

# Set Go environment variables needed by other scripts
export GOPATH="/opt/gopath"
export GOROOT="/opt/go/"
PATH=$GOROOT/bin:$GOPATH/bin:$PATH

#install golang
#apt-get install --yes golang
./installGolang.sh

# Setup golang cross compile
#./golang_crossCompileSetup.sh

# Install NodeJS
./installNodejs.sh

# Install GRPC
./golang_grpcSetup.sh

# Install RocksDB
./installRocksDB.sh

# Now clean up the VM in preparation to package it up
apt-get clean
echo "Preparing filesystem for packaging.  Please be patient..."
(sudo dd if=/dev/zero of=/EMPTY bs=1M) > /dev/null 2>&1 || true
sudo rm -f /EMPTY
cat /dev/null > ~/.bash_history && history -c
echo "Filesystem prepared!"
