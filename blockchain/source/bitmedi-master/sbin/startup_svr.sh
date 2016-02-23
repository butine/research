#!/bin/sh

nohup factomd > ./factomd.log 2>1 &
nohup fctwallet > ./fctwallet.log 2>1 &
