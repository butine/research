var Web3 = require('web3');
var express = require('express');
var Async = require('async');
var redis = require("redis");

var app = express();
var web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider("http://localhost:8545"));

var BlockObject = require('./lib/block.js');
var Block = new BlockObject(web3);
var max = Block.getBlockNum();

var config = require('./config/config.js');
var Dbobject = require('./lib/poolClient.js');
var DB = new Dbobject(config.pooldb);
DB.createPool();

var repairStatu = false;
var step = 5;
var deleteBlocks = "";

var blockNum = 0;


/*Async.series([
    function(cb) {
    	console.log("deleteBlock function Run");
    	deleteBlock(function(error,data){cb(error,data);});
    },
    function(cb) {
    	console.log("deleteTmpTrans run");
    	deleteTmpTrans(function(error,data){cb(error,data);});
    },
    function(cb) {
    	console.log("deleteTrans run");
    	deleteTrans(function(error,data){cb(error,data);});
    },
    function(cb) {
    	console.log("get max block num");
    	getMaxBlockNum(function(error,data){cb(error,data);});
    } 
], function(err, results) {
	if(!err){
		blockNum = results[3];
		setInterval(function(){
			repairBlock(blockNum);
		}, 1000);
		setInterval(function(){
			repairTransactions();
		}, 1000);
		setInterval(function(){
			checkBlock();
		}, 30000);
	}
});*/

function checkBlock(){

}

function getMaxBlockNum(callback){
	var order = "block DESC";
	DB.findOne("blocks", "*", callGetMaxBlock, {'limit':1, 'order':order, 'params':{callback:callback}});
}

function deleteTrans(callback){
	var condition = "blocknumber IN(" +deleteBlocks+ ")";
	DB.delete("transactions", {condition:condition, params:{callback:callback}}, callDelete);
}

function deleteTmpTrans(callback){
	var condition = "block IN(" +deleteBlocks+ ")";
	DB.delete("tmp_transactions", {condition:condition, params:{callback:callback}}, callDelete);
}

function deleteBlock(callback){
	var order = "block DESC";
	DB.findOne("blocks", "*", callDeleteBlock, {'limit':1, 'order':order, 'params':{callback:callback}});
}

function callGetMaxBlock(row, params){
	var callback = params.params.callback;
	if(row && typeof(row) == 'object'){
		callback(null, row.block);
	}else{
		callback("find max block error！", row.block);
	}
}

function callDelete(result, params){
	var callback = params.params.callback;
	callback(null, null);
}

function callDeleteBlock(row, params){
	if(row && typeof(row) == 'object'){
		var callback = params.params.callback;
		var max = parseInt(row.block);
		for (var i=0; i <step; i++) {
			if(i != 0){
				deleteBlocks += "," + (max -i);
			}else{
				deleteBlocks += (max -i);
			}
		}
		var condition = "block IN(" +deleteBlocks+ ")";
		DB.delete("blocks", {condition:condition, params:{callback:callback}}, callDelete);
	}
}

function getBlockFormatData(data){
	var insertData = {
		block : data.number,
		miner : data.miner,
		hash : data.hash,
		difficulty : data.difficulty.toNumber(),
		gas_limit : data.gasLimit,
		gas_used : data.gasUsed,
		parent_hash : data.parentHash,
		nonce : data.nonce,
		sha3uncles : data.sha3Uncles,
		transactions_root : data.transactionsRoot,
		state_root : data.stateRoot,
		receipt_root : data.receiptRoot,
		total_difficulty : data.totalDifficulty.toNumber(),
		size : data.size,
		extra_data : data.extraData,
		time : data.timestamp
	};
	return insertData;
}

function setBlockNum(result, params){
	if(result && typeof(result['affectedRows']) != 'undefined'){
		if(result['affectedRows'] == 1){
			blockNum = params.params.block;
			console.log("set blockNum:" + blockNum);
		}
	}
}

function callInsertTran(result, params){
	if(result.length == 0){
		var transData = params.params.data;
		DB.insert("tmp_transactions", transData);
	}
}

function callRunBlock(result, params){
	if(result.length == 0){
		var insertData = params.params.data;
		var transactions = params.params.trans;
		DB.insert("blocks", insertData, setBlockNum, {'params':{block:insertData.block}});
		if(transactions.length>0){
			for(var i=0; i<transactions.length; i++){
				var transData = {id:transactions[i], block:insertData.block};
				var condition = "t.id='" + transactions[i] + "'";
				DB.findOne("tmp_transactions", "*", callInsertTran, {'condition':condition, 'params':{data:transData}});
			}
		}
	}
}

function runBlock(num){
	console.log("runBlock:" + num);
	var data = Block.getBlock(num);
	var insertData = getBlockFormatData(data);
	var transactions = (data.transactions.length > 0) ? data.transactions : [];
	var condition = "t.block=" + insertData.block;
	DB.findOne("blocks", "*", callRunBlock, {'condition':condition, 'params':{data:insertData, trans:transactions}});
}


function repairBlock(start){
	if(repairStatu === false){
		repairStatu = true;
		var num = start;
		var max = Block.getBlockNum();
		Async.whilst(
		    function() { return num < max},
		    function(cb) {
		        console.log('num: ', num);
		        num++;
		        runBlock(num);
		        setTimeout(cb, 20);
		    },
		    function(err) {
		    	if(!err || err === null){
		    		repairStatu = false;
		    	}
		    }
		);
	}else{
		console.log("repairBlock is runing......");
	}
}

function getInsertTranData(data){
	var insert = {
		hash : data.hash,
		nonce : data.nonce,
		blockhash : data.blockHash,
		blocknumber : data.blockNumber,
		tindex : data.transactionIndex,
		tfrom : data.from,
		towhere : data.to,
		value : data.value.toNumber(),
		gas : data.gas,
		gasprice : data.gasPrice.toNumber(),
		input : data.input
	};
	return insert;
}

function callDeleteTran(result, params){
	if(result && typeof(result['affectedRows']) != 'undefined'){
		if(result['affectedRows'] == 1){
			var id = params.params.id;
			var condition = "id='" + id +"'";
			DB.delete("tmp_transactions", {condition:condition});
		}
	}
}

function callInsertTran(result, params){
	if(result.length == 0){
		var data = params.params.data;
		var insert = getInsertTranData(data);
		DB.insert("transactions", insert, callDeleteTran, {'params':{id:data.hash}});
	}
}

function runTransactions(rows){
	
	if(rows.length > 0){
		for(var i=0; i<rows.length; i++){
			var data = Block.getTransaction(rows[i]['id']);
			var condition = "t.hash='"+data.hash+"' AND t.tindex=" + data.transactionIndex;
			DB.findOne("transactions", "*", callInsertTran, {'condition':condition, 'params':{data:data}});
		}
	}
}

function repairTransactions(){
	DB.query("tmp_transactions", "*", runTransactions);
}






