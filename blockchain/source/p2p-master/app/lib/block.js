module.exports = Block;

function Block(web3){
	this.web3 = web3;
}

Block.prototype.init = function(){
	if(!this.web3){
		throw new Error("Block is not init!");
		return false;
	}else{
		return true;
	}
}

Block.prototype.getBlockNum = function(){
	if(this.init()){
		var BlockNum = this.web3.eth.blockNumber;
		return BlockNum;
	}
}

Block.prototype.getBlock = function(num){
	if(this.init()){
		var object = this.web3.eth.getBlock(num);
		return object;
	}
}

Block.prototype.newAccount = function(){
	if(this.init()){
		var account = this.web3.personal.newAccount("");
		if(!account){
			throw new Error("account is create fail!");
		}else{
			return account;
		}
	}
}

Block.prototype.getAccounts = function(){
	if(this.init()){
		var accounts = this.web3.eth.accounts;
		return accounts;
	}
}

Block.prototype.getTransaction = function(hash){
	if(this.init()){
		var object = this.web3.eth.getTransaction(hash);
		return object;
	}
}

Block.prototype.getBalance = function(hash){
	if(this.init()){
		var num = this.web3.eth.getBalance(hash);
		return num;
	}
}



