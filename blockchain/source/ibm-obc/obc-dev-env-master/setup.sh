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

# Installs the stuff needed to get the VirtualBox Ubuntu (or other similar Linux
# host) into good shape to run our development environment.

# ALERT: if you encounter an error like:
# error: [Errno 1] Operation not permitted: 'cf_update.egg-info/requires.txt'
# The proper fix is to remove any "root" owned directories under your update-cli directory
# as source mount-points only work for directories owned by the user running vagrant

# Stop on first error
set -e

# Update system
apt-get update -qq

# Prep apt-get for docker install
apt-get install -y apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# Add docker repository
echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list

# Update system
apt-get update -qq

# Storage backend logic
case "${DOCKER_STORAGE_BACKEND}" in
  aufs|AUFS|"")
    DOCKER_STORAGE_BACKEND_STRING="aufs" ;;
  btrfs|BTRFS)
    # mkfs
    apt-get install -y btrfs-tools
    mkfs.btrfs -f /dev/sdb
    rm -Rf /var/lib/docker
    mkdir -p /var/lib/docker
    . <(sudo blkid -o udev /dev/sdb)
    echo "UUID=${ID_FS_UUID} /var/lib/docker btrfs defaults 0 0" >> /etc/fstab
    mount /var/lib/docker

    DOCKER_STORAGE_BACKEND_STRING="btrfs" ;;
  *) echo "Unknown storage backend ${DOCKER_STORAGE_BACKEND}"
     exit 1;;
esac

# Install docker
apt-get install -y linux-image-extra-$(uname -r) apparmor docker-engine

# Configure docker
echo "DOCKER_OPTS=\"-s=${DOCKER_STORAGE_BACKEND_STRING} -r=true --api-enable-cors=true -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock ${DOCKER_OPTS}\"" > /etc/default/docker

curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
service docker restart
usermod -a -G docker vagrant # Add vagrant user to the docker group

# Test docker
docker run --rm busybox echo All good

# Install Python, pip, behave, nose
apt-get install --yes python-setuptools
apt-get install --yes python-pip
pip install behave
pip install nose

# updater-server, update-engine, and update-service-common dependencies (for running locally)
pip install -I flask==0.10.1 python-dateutil==2.2 pytz==2014.3 pyyaml==3.10 couchdb==1.0 flask-cors==2.0.1 requests==2.4.3

# install ruby and apiaryio
#apt-get install --yes ruby ruby-dev gcc
#gem install apiaryio

# Set Go environment variables needed by other scripts
export GOPATH="/opt/gopath"
export GOROOT="/opt/go/"
export GO15VENDOREXPERIMENT=1
PATH=$GOROOT/bin:$GOPATH/bin:$PATH

#install golang deps
./installGolang.sh

# Configure RocksDB related deps
sudo apt-get install -y libsnappy-dev
sudo apt-get install -y zlib1g-dev
sudo apt-get install -y libbz2-dev

# Run go install - CGO flags for RocksDB
cd $GOPATH/src/github.com/openblockchain/obc-peer
CGO_CFLAGS="-I/opt/rocksdb/include" CGO_LDFLAGS="-L/opt/rocksdb -lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy" go install

# Copy protobuf dir so we can build the protoc-gen-go binary. Then delete the directory.
mkdir -p $GOPATH/src/github.com/golang/protobuf/
cp -r $GOPATH/src/github.com/openblockchain/obc-peer/vendor/github.com/golang/protobuf/ $GOPATH/src/github.com/golang/
go install -a github.com/golang/protobuf/protoc-gen-go
rm -rf $GOPATH/src/github.com/golang/protobuf

# Compile proto files
# /openchain/obc-dev-env/compile_protos.sh

# Create directory for the DB
sudo mkdir -p /var/openchain
sudo chown -R vagrant:vagrant /var/openchain

# Ensure permissions are set for GOPATH
sudo chown -R vagrant:vagrant $GOPATH

# Update limits.conf to increase nofiles for RocksDB
sudo cp /openchain/obc-dev-env/limits.conf /etc/security/limits.conf
