# BITMEDI
A blockchain solution for Medical Records Keeping


- The goal is to put medical records/prescriptions onto the blockchain
- Maintains permanent, immutable and timestamped medical records with levels of security.
- Allows patients/doctors to access their medical records any where from the world;
- Reduce insurance fraud and low costs by simplify medial history check.

## OverView

![](http://images2015.cnblogs.com/blog/554579/201601/554579-20160110092544075-2033874255.png)

## User Requirements
a browser like as Chrome/Firfox keep latest version

## Dev Requirements
- [factom](http://factom.org/howto.html "factom") release v1
- node.js 4.2.4 or above
- python 2.7

## Getting started
1. install factomd/fctwallet/factom-cli in your server
1. entry path *sbin* to execute *startup_svr.sh*
you should ensure services have been started with command *netstat -tanp*
find out port 8088/8089 state listening, progress name *factomd/fctwallet*
1.  execute *init_db.py* to create table on sqlite3
you can give other database to instead of sqlite3
1.  execute *init_by_cli.sh* with your factom private key and a new entry key
to generate your public address to service
1. see factom-cli commond with help: *factom-cli* -help, then execute:
*factom-cli balances*

## License
BitMedi is released under the terms of the MIT license. See http://mit-license.org for more information.
