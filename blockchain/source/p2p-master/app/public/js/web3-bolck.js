var web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider("http://localhost:8545"));
var accounts = web3.eth.accounts;
var defaultAccount = getDefaultAccount();
if(defaultAccount != -1){
    web3.eth.defaultAccount = defaultAccount;
}
var coindbContract = web3.eth.contract([{"constant":true,"inputs":[{"name":"name","type":"bytes32"},{"name":"_target","type":"address"},{"name":"_proxy","type":"address"}],"name":"isApprovedFor","outputs":[{"name":"_r","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"starttime","type":"uint256"},{"name":"endtime","type":"uint256"},{"name":"rate","type":"uint256"},{"name":"basevalue","type":"uint256"}],"name":"calc","outputs":[{"name":"totalvalue","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"_offerCurrency","type":"bytes32"},{"name":"_offerValue","type":"uint256"},{"name":"_wantCurrency","type":"bytes32"},{"name":"_wantValue","type":"uint256"}],"name":"placeOrder","outputs":[{"name":"_offerId","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"name","type":"bytes32"}],"name":"isInit","outputs":[{"name":"_r","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"to","type":"address"},{"name":"val","type":"uint256"}],"name":"getCNY","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"approveP2P","outputs":[{"name":"_success","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"addr","type":"address"}],"name":"getAccountHash","outputs":[{"name":"hash","type":"string"}],"type":"function"},{"constant":true,"inputs":[{"name":"addr","type":"address"}],"name":"isP2P","outputs":[{"name":"_success","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"_offerId","type":"uint256"}],"name":"cancelOrder","outputs":[{"name":"_success","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"name","type":"bytes32"}],"name":"status","outputs":[{"name":"_r","type":"uint8"}],"type":"function"},{"constant":true,"inputs":[{"name":"name","type":"bytes32"},{"name":"_a","type":"address"}],"name":"coinBalanceOf","outputs":[{"name":"_r","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[],"name":"getSender","outputs":[{"name":"_r","type":"address"}],"type":"function"},{"constant":false,"inputs":[{"name":"_offerId","type":"uint256"}],"name":"matchOrder","outputs":[{"name":"_success","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"name","type":"bytes32"},{"name":"title","type":"string"},{"name":"note","type":"string"},{"name":"starttime","type":"uint256"},{"name":"endtime","type":"uint256"},{"name":"value","type":"uint256"},{"name":"ratetpl","type":"uint256"},{"name":"ratevalue","type":"uint256"}],"name":"newCoin","outputs":[],"type":"function"},{"constant":true,"inputs":[{"name":"name","type":"bytes32"}],"name":"canTrade","outputs":[{"name":"_r","type":"bool"}],"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"p2pList","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"accountHash","outputs":[{"name":"","type":"string"}],"type":"function"},{"constant":true,"inputs":[{"name":"name","type":"bytes32"},{"name":"_proxy","type":"address"}],"name":"isApproved","outputs":[{"name":"_r","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"to","type":"address"},{"name":"val","type":"uint256"}],"name":"sendCNY","outputs":[{"name":"_success","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"name","type":"bytes32"},{"name":"user","type":"address"}],"name":"coinRateValue","outputs":[{"name":"_r","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"orders","outputs":[{"name":"creator","type":"address"},{"name":"offerCurrency","type":"bytes32"},{"name":"offerValue","type":"uint256"},{"name":"wantCurrency","type":"bytes32"},{"name":"wantValue","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[],"name":"getCount","outputs":[{"name":"_r","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"name","type":"bytes32"},{"name":"_a","type":"address"}],"name":"approve","outputs":[],"type":"function"},{"constant":true,"inputs":[{"name":"name","type":"bytes32"}],"name":"coinRateTpl","outputs":[{"name":"_r","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"coins","outputs":[{"name":"starttime","type":"uint256"},{"name":"endtime","type":"uint256"},{"name":"value","type":"uint256"},{"name":"name","type":"bytes32"},{"name":"title","type":"string"},{"name":"note","type":"string"},{"name":"owner","type":"address"},{"name":"ratetpl","type":"uint256"},{"name":"ratevalue","type":"uint256"},{"name":"status","type":"uint8"}],"type":"function"},{"constant":false,"inputs":[{"name":"name","type":"bytes32"},{"name":"user","type":"address"}],"name":"redeem","outputs":[{"name":"_success","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"},{"name":"_hash","type":"string"}],"name":"approveAccount","outputs":[{"name":"_success","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"ids","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"bankList","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"name","type":"bytes32"}],"name":"coinBalance","outputs":[{"name":"_r","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"},{"name":"hash","type":"bytes32"}],"name":"approveBank","outputs":[{"name":"_success","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"name","type":"bytes32"},{"name":"value","type":"uint256"}],"name":"purchase","outputs":[{"name":"_success","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"addr","type":"address"}],"name":"isBank","outputs":[{"name":"_success","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"name","type":"bytes32"},{"name":"_a","type":"address"}],"name":"coinValueOf","outputs":[{"name":"_r","type":"uint256"}],"type":"function"},{"inputs":[],"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"currencyPair","type":"bytes32"},{"indexed":true,"name":"seller","type":"address"},{"indexed":false,"name":"offerValue","type":"uint256"},{"indexed":true,"name":"buyer","type":"address"},{"indexed":false,"name":"wantValue","type":"uint256"}],"name":"Traded","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"name","type":"bytes32"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"Sent","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":false,"name":"name","type":"bytes32"},{"indexed":false,"name":"id","type":"uint256"}],"name":"Create","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"name","type":"bytes32"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"Purchase","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"name","type":"bytes32"}],"name":"Redeem","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"GetCNY","type":"event"}]
);

var address = "0x15d00beda90f79236aa0181ff101b3957b214ef3";
var coindb = coindbContract.at(address);


function getDefaultAccount(){
    var account = -1;
    try{
        account =  web3.db.getString("p2pdb", "defaultAccount");
    }catch(e){
        account = -1;
    }
    return account;
}

function checkDefaultAccount(){
    var flag = 1;
   if(!$.isArray(accounts) || accounts.length<=0){
        flag = -1;//没有可选账户
    }else if(getDefaultAccount() == -1){
        flag = -2;//没有选择可选账户
    }
    return flag;
}

function setDefaultAccount(account){
    var value = web3.eth.getBalance(account);
    var min = web3.toBigNumber(web3.toWei(100, "ether"))
    if(!min.lessThan(value)){
        var flag = false;
    }else {
        var flag = web3.db.putString("p2pdb", "defaultAccount", account);
    }
    return flag;
}

function newCoin(name, title, create_note, s_time, end_time, amount, ratetpl, rate, defaults) {
    var lockflag = web3.personal.unlockAccount(defaults, "");
    var tx = coindb.newCoin.sendTransaction(name, title, create_note, s_time, end_time, amount, ratetpl, rate, {gas:1000000, from:defaults});
    return tx;
};

function buy(am, name){
	var tid = coindb.purchase(name, am);
	return tid;
}

function openMacoinDialog(id, params)
{
	var msg = '系统处理中,请稍候....';
	var defaults = {
		'width':550,
		'height':350,
		'modal': true,
		'title':'操作提示',
		'autoOpen': false
	};
	if(typeof(params) != 'undefined' && typeof(params) == 'object'){
		for(key in params){
			if(typeof(defaults[key]) != 'undefined') defaults[key] = params[key];
			if(key == 'msg') msg = params['msg'];
		}
	}
	$("#" + id).dialog(defaults);
	$("#" + id).dialog('open');
 	$("#" + id).html(msg);
}


function getLocalTime(tm){
    var date = new Date(tm*1000); //转换成时间对象，这就简单了
    var year = date.getFullYear();  //获取年
    var month = date.getMonth()+1;  //获取年
    var day = date.getDate(); 
    return year+"-"+month+"-"+day; 
}

function getJxType(t){
	var type = {
		1 : "按天复利",
		2 : "按年复利",
		3 : "固定利率"
	};
	return type[t];
}

function setWeb3Data(name,  params, key, isrepeace){
    var isr = (typeof(isrepeace) != 'undefined') ? isrepeace : 0;
    var data = {};
    try{
        var data =  web3.db.getString("p2pdb", name);
        data = jQuery.parseJSON(data);
        if(typeof(data[key]) == 'object' && data[key]){
            if(isr == 1){
                data[key] = params;
            }
        }else{
            data[key] = params;
        }
    }catch(e){
        data[key] = params;
    }
    var str = $.toJSON(data);
    return web3.db.putString("p2pdb", name, str);
}

function getWeb3Data(name, key){
    var mykey = (typeof(key) != 'undefined') ? key : '';
    var result = {};
    try{
        var data =  web3.db.getString("p2pdb", name);
        data = jQuery.parseJSON(data);
        if(mykey != "" && typeof(data[mykey]) == 'object'){
            result = data[key];
        }else{
          result = data;
        }
    }catch(e){}
    return result;
}

function delWeb3Data(name, key){
    try{
        var data =  web3.db.getString("p2pdb", name);
        data = jQuery.parseJSON(data);
        if(key != "" && typeof(data[key]) == 'object'){
            delete data[key];
            var str = $.toJSON(data);
            web3.db.putString("p2pdb", name, str);
        }
    }catch(e){}
    return true;
}

