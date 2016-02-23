#!/bin/sh

if [ $# != 2 ];then
	echo "Usage: $0 Fctkey EC_key"
	exit 0
fi

factom-cli newaddress fct fct_addr_1 $1
factom-cli newaddress ec ec_addr_1 $2

#factom-cli newaddress ec zeros Es2Rf7iM6PdsqfYCo3D1tnAR65SkLENyWJG1deUzpRMQmbh9F3eG
#factom-cli newtransaction trans1
#factom-cli addinput trans1 sand 10
#factom-cli addecoutput trans1 zeros 10
#factom-cli addfee trans1 sand
#factom-cli sign trans1
#factom-cli transactions
#factom-cli submit trans1

