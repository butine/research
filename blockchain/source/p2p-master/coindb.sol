contract CoinDb {
    mapping (uint => Coin) public coins;
    mapping (bytes32 => uint) public ids;
    mapping (address => string) public accountHash;
    mapping (address => bool) public p2pList;
    mapping (address => bool) public bankList;
    address public owner;
    uint m_count;

    mapping ( uint => Order ) public orders;
    uint nextOrderId = 1;

    event Traded(bytes32 indexed currencyPair, address indexed seller, uint256 offerValue, address indexed buyer, uint256 wantValue);
	event Sent(address indexed from, address indexed to, bytes32 name, uint amount);
    event Create(address indexed from, bytes32 name, uint id);
    event Purchase(address indexed from, address indexed to, bytes32 name, uint amount);
    event Redeem(address indexed from, address indexed to, bytes32 name);
    event GetCNY(address indexed from, address indexed to, uint amount);
 
    struct Coin 
    {
	    mapping (address => uint) balances;
	    mapping (address => mapping (address => bool)) approved;
	    uint     starttime;
	    uint     endtime;
        uint     value;
	    bytes32  name;
	    string   title;
	    string   note;
	    address  owner;
	    uint     ratetpl;
	    uint     ratevalue;
	    uint8    status;
    }

    struct Order {
        address creator;
        bytes32 offerCurrency;
        uint offerValue;
        bytes32 wantCurrency;
        uint wantValue;
    }

    function CoinDb() {
    	owner = msg.sender;
    	m_count = 0;
    	newCoin("CNY", "人民币", "银行发行比特人民币代币", 0, 0, 1000000000000, 0, 0);
    }

    function getSender() constant returns(address _r) {
        return msg.sender;
    }

    //status 0 ＝> not init 
    //       1 => create
    //       2 => complete
    //       3 => finish
	function newCoin(bytes32 name, string title, string note, uint starttime, uint endtime, uint value, uint ratetpl, uint ratevalue) {
		if (endtime == 0) {
			endtime = block.timestamp;
		}
	    if (ids[name] == 0 && endtime >= block.timestamp) {
	        ids[name] = m_count+1;
	        m_count++;
	    } else {
	        throw;
	    }
	    uint id = ids[name];
	    coins[id].balances[msg.sender] = value;
	    coins[id].starttime = block.timestamp;
	    coins[id].endtime = endtime;
        coins[id].value = value;
	    coins[id].name = name;
	    coins[id].title = title;
	    coins[id].note = note;
	    coins[id].ratetpl = ratetpl;
	    coins[id].ratevalue = ratevalue;
	    coins[id].owner = msg.sender;
	    coins[id].status = 1; //created
		Create(msg.sender, name, id);
	}
	
	function getCount() constant returns(uint _r) {
	    return m_count; 
	}

	function getAccountHash(address addr) constant returns(string hash) {   
	    hash = accountHash[addr];
	}
	
	function isP2P(address addr) constant returns (bool _success) {
	    return p2pList[addr];
	}
	
	function isBank(address addr) constant returns (bool _success) {
	    return bankList[addr];
	}
	
	function approveP2P(address addr) returns (bool _success) {
	    if (msg.sender == owner) {
	        p2pList[addr] = true;
	        return true;
	    }
	    return false;
	}
	
    function approveBank(address addr, bytes32 hash) returns (bool _success) {
	    if (msg.sender == owner) {
	        bankList[addr] = true;
	        return true;
	    }
	    return false;
    }	
	
	function approveAccount(address addr, string _hash) returns(bool _success) {
	    if (isP2P(msg.sender)) {
	        accountHash[addr] = _hash;
	        return true;
	    }
	    return false;
	}
	
	function purchase(bytes32 name, uint value) returns (bool _success)  {
	    _success = false;
	    if (!isInit(name)) {
	        throw;
	    }
	    uint id = ids[name];
	    Coin coin = coins[id];
	    if (coin.status != 1) {
	        throw;
	    }
	    if (coins[1].balances[msg.sender] >= value && coin.balances[coin.owner] >= value) {
	        coin.balances[coin.owner] -= value;
            if (coin.balances[coin.owner] == 0) {
                coin.status = 2;
            }
	        coins[1].balances[msg.sender] -= value;
	        coins[1].balances[coin.owner] += value;
	        coin.balances[msg.sender] += value;
	        Purchase(msg.sender, coin.owner, name, value);
	        _success = true;
	    }
	}

    function redeem(bytes32 name, address user) returns (bool _success) {
        _success = false;
	    uint id = ids[name];
	    Coin coin = coins[id];
	    if (coin.status != 1 && block.timestamp < coin.endtime) {
	        throw;
	    }
	    if (coin.owner != msg.sender) {
	        throw;
	    }
        uint value = calc(coin.starttime, block.timestamp, coin.ratevalue, coin.balances[user]);
        //赎回方有足够的余额
        if (coins[1].balances[msg.sender] >= value) {
            coins[1].balances[msg.sender] -= value;
            coins[1].balances[user] += value;
            coin.balances[msg.sender] += coin.balances[user];
            coin.balances[user] = 0;
            Redeem(msg.sender, user, name);
            return _success;
        }
    }

	function isApprovedFor(bytes32  name, address _target,address _proxy) constant returns(bool _r) {
	    if (!isInit(name)) {
	        return false;
	    }
	    uint id = ids[name];
	    Coin coin = coins[id];
	    return coin.approved[_target][_proxy];
	}

	function isApproved(bytes32  name, address _proxy) constant returns(bool _r) {
	    if (!isInit(name)) {
	        return false;
	    }
	    uint id = ids[name];
	    Coin coin = coins[id];
	    return coin.approved[msg.sender][_proxy];
	}
    
    //it's private 
	function sendCoinFrom(bytes32  name, address _from,uint256 _val,address _to) private returns (bool _success)  {
	    _success = false;
        //has init and not finish
	    if (!canTrade(name)) {
	        throw;
	    }
	    uint id = ids[name];
	    Coin coin = coins[id];
		if (coin.balances[_from] >= _val && coin.approved[_from][msg.sender]) {
			coin.balances[_from] -= _val;
			coin.balances[_to] += _val;
			Sent(_from, _to, name, _val);
			_success = true;
		}
	}
	
	//it's private
	function sendCoin(bytes32  name, uint256 _val,address _to) private returns (bool _success) {
        //has init and not finish
        _success = false;
	    if (!canTrade(name)) {
	        throw;
	    }
	    uint id = ids[name];
	    Coin coin = coins[id];
		if (coin.balances[msg.sender] >= _val) {
			coin.balances[msg.sender] -= _val;
			coin.balances[_to] += _val;
			Sent(msg.sender, _to, name, _val);
			_success = true;
		}
	}

	//only from or to has one bank address, can be send.
	function sendCNY(address to, uint val) returns (bool _success) {
		if (!isBank(msg.sender) && !isBank(to)) {
			throw;
		}
		return sendCoin("CNY", val, to);
	}

	//notify banck to send cny to me
	function getCNY(address to, uint val) {
		if (!isBank(to)) {
			throw;
		}
		GetCNY(msg.sender, to, val);
	}

	function coinBalanceOf(bytes32  name, address _a) constant returns(uint256 _r){
	    if (!isInit(name)) {
	        throw;
	    }
	    uint id = ids[name];
	    Coin coin = coins[id];
	    return coin.balances[_a];
	}

	function status(bytes32 name) constant returns(uint8 _r) {
	    uint id = ids[name];
	    Coin coin = coins[id];
	    return coin.status;
	}

	function isInit(bytes32 name) constant returns(bool _r) {
        uint id = ids[name];
        //has init and not finish
	    if (id > 0) {
	        return true;
	    }
	    return false;
	}
	
	function canTrade(bytes32 name) constant returns(bool _r) {
	    uint id = ids[name];
	    Coin coin = coins[id];
        //has init and not finish
	    if (coin.status == 1 || coin.status == 2) {
	        return true;
	    }
	    return false;
	}

	function coinBalance(bytes32  name) constant returns(uint256 _r){
	    if (!isInit(name)) {
	        throw;
	    }
	    uint id = ids[name];
	    Coin coin = coins[id];
	    return coin.balances[msg.sender];
	}

	function approve(bytes32  name, address _a) {
        //has init and not finish
	    if (!canTrade(name)) {
	        throw;
	    }
	    uint id = ids[name];
	    Coin coin = coins[id];
	    coin.approved[msg.sender][_a] = true;
	}

	function coinValueOf(bytes32  name, address _a)constant returns(uint256 _r) {
	    if (!isInit(name)) {
	        throw;
	    }
	    uint id = ids[name];
	    Coin coin = coins[id];
	    return coin.balances[_a];
	}

	function coinRateValue(bytes32 name, address user) constant returns(uint256 _r) {
	    if (!isInit(name)) {
	        throw;
	    }
	    uint id = ids[name];
	    Coin coin = coins[id];
	    return calc(coin.starttime, block.timestamp, coin.ratevalue, coin.balances[user]);
	}

	function coinRateTpl(bytes32 name) constant returns(uint256 _r) {
	    if (!isInit(name)) {
	        throw;
	    }
	    uint id = ids[name];
	    Coin coin = coins[id];
	    return coin.ratetpl;
	}
	
    function calc(uint starttime, uint endtime, uint rate, uint basevalue)  constant returns(uint totalvalue){
        if (endtime <= starttime) {
		   return basevalue;
		}
        uint ndays = (endtime- starttime) / (24 * 60 * 60) + 1;
		for (uint i=0; i< ndays; i++) {
		    basevalue = basevalue + basevalue * rate / 100000 ;
		}
	    totalvalue = basevalue ;
    }
	
	

    function placeOrder(bytes32 _offerCurrency, uint _offerValue, bytes32 _wantCurrency, uint _wantValue) returns (uint256 _offerId) {
        if (!canTrade(_offerCurrency) || !canTrade(_wantCurrency) ) {
	        throw;
	    }
        uint id1 = ids[_offerCurrency];
        uint id2 = ids[_wantCurrency];
        if (id1 != 1 && id2 != 1) {
            throw;
        }
        Coin offer = coins[id1];
        Coin want  = coins[id2];
        if (sendCoinFrom(_offerCurrency, msg.sender, _offerValue, this)) {
            _offerId = nextOrderId;
            nextOrderId += 1;
            orders[_offerId].creator = msg.sender;
            orders[_offerId].offerCurrency = _offerCurrency;
            orders[_offerId].offerValue = _offerValue;
            orders[_offerId].wantCurrency = _wantCurrency;
            orders[_offerId].wantValue = _wantValue;
        }  else {
            _offerId = 0;
        }
    }

    function matchOrder(uint _offerId) returns (bool _success) {
        bytes32 offer = orders[_offerId].offerCurrency;
        bytes32  want  = orders[_offerId].wantCurrency;
        _success = false;
        if (sendCoinFrom(want, msg.sender, orders[_offerId].wantValue, orders[_offerId].creator)) {
            throw;
        }
        if (sendCoin(offer, orders[_offerId].offerValue, msg.sender)) {
            throw;
        }
        bytes32 currencyPair = bytes32(((uint256(orders[_offerId].offerCurrency) / 2**32) * 2**128) + (uint256(orders[_offerId].wantCurrency) / 2**32));
        Traded(currencyPair, orders[_offerId].creator, orders[_offerId].offerValue, msg.sender, orders[_offerId].wantValue);
        orders[_offerId].creator = 0;
        orders[_offerId].offerCurrency = 0;
        orders[_offerId].offerValue = 0;
        orders[_offerId].wantCurrency = 0;
        orders[_offerId].wantValue = 0;
        _success = true;
    }

    function cancelOrder(uint _offerId) returns (bool _success) {
        _success = false;
        if (sendCoin(orders[_offerId].offerCurrency, orders[_offerId].offerValue, orders[_offerId].creator)) {
            return false;
        }
        orders[_offerId].creator = 0;
        orders[_offerId].offerCurrency = 0;
        orders[_offerId].offerValue = 0;
        orders[_offerId].wantCurrency = 0;
        orders[_offerId].wantValue = 0;
        _success = true;
    }
}

