#!/bin/bash

helpme()
{
  cat <<HELPMEHELPME
Syntax: sudo $0

Installs the stuff needed for grpc usage.

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



# ----------------------------------------------------------------
# NOTE: For instructions, see https://github.com/google/protobuf
#
# ----------------------------------------------------------------

# First install protoc
cd /tmp
git clone https://github.com/google/protobuf.git
cd protobuf
git checkout 12fb61b292d7ec4cb14b0d60e58ed5c35adda3b7
#unzip needed for ./autogen.sh
sudo apt-get install -y unzip
sudo apt-get install -y autoconf
sudo apt-get install -y build-essential libtool
./autogen.sh
# NOTE: By default, the package will be installed to /usr/local. However, on many platforms, /usr/local/lib is not part of LD_LIBRARY_PATH.
# You can add it, but it may be easier to just install to /usr instead.
#
# To do this, invoke configure as follows:
#
# ./configure --prefix=/usr
#
#./configure
./configure --prefix=/usr

make
make check
sudo make install
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
