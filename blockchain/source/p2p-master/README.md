# P2P lending platform On Block chain

# Roles： 
* adminstrator
* bank
* P2P lending platform
* personal or company
* block chain

# APIS

## the adminstrator api

#### the system has multi bank and P2P lending platform
* approveBank(address, name) approve bank with address
* approveP2P(address, name)  approve P2P lending platform with his address

## the bank api

* sendCNY(address, amount) send BitCNY or BitUSD to user address

About BitCNY：

like Bank-securities transfer on  trade securities,
the money can't be transfer from person to person,
it's can only be used to buy stock.
the BitCNY on block chain can't be transfer from 
person to person, it's can only be used to buy BitBond.

## the P2P lending platform api

* approveAccount(address, hash)  validate user info, hash is sha3(name + id + note)
* approveBond(id) validate the bond

## debit side
* register(name, id, note)  register in p2p lending platform 
* check(name, id, note)     check the user info is ok
* getCNY(amount)            request for CNY, bank call sendCNY to user. 
* purchase(name, value)     purchase some 

## credit side
* register(name, id, note)     register in p2p lending platform  
* newBond(...)                 publish bond
* sendCNY(bankaddress, amount) send BitCNY to bank
* redeem(name, user)           redeem the bond


## trades api

* placeOrder(offerCurrency, offerValue, wantCurrency, wantValue) place order
* matchOrder(orderId)  match order
* cancelOrder(orderId) cancel order
* orders()             order list

##All  Pages：

####帐户

在线开户：
* 选择以太坊账户，开户，提交用户资料。

校验身份:
* 检查投资者资料。

个人帐户中心:
* 个人帐户的信息（人民币的余额）
* 个人发行的债券
* 个人购买的债券

####银行

银行管理后台：
* 管理后台检查到银证转账申请，sendCNY,发送比特人民币给对方。

####P2P公司

P2P贷款公司后台：

* 审核用户资料
* 审核债券发行
* 审核资产抵押

####债券

债券列表
添加债券

####二级市场交易

卖出：
* 卖出债券
* 可购买列表

买入：
* 买入债券
* 可卖出债券列表

#流程说明：

#### 债券发行流程

* ［贷款方］在 ［P2P公司］开户(实名认证)
* ［贷款方］抵押物品［P2P公司］
* ［贷款方］发行［债券］
* ［P2P公司］审核 ［债券］ => 债券生效

####  购买债券流程

* ［投资方］资金进入 ［银行］
* ［银行］发送 ［比特人民币］ 给 ［投资方］
* ［投资方］认购［债券］=> （［比特人民币］转入 ［贷款方］，［债券］ 转入［投资方］）
* ［投资方］拥有 ［债券］，等待到期兑付，或者在 ［二级市场］ 转让
* ［贷款方］拥有 ［比特人民币］，到［银行］兑付 ［资金］

#### 债券兑付流程

* ［贷款方］资金进入［银行］
* ［银行］发送 ［比特人民币］ 给 ［贷款方］
* ［贷款方］兑付 ［债券］=> (［比特人民币］转入 ［投资方］，［债券］转入［贷款方］)
* ［投资方］拥有 ［比特人民币］，到［银行］兑付 ［资金］
* ［贷款方］拥有 ［债券］债券的生存周期结束，不能进行人和操作。

#背景说明

###P2P 小额贷款 区块链实现：

现在P2P小额贷款公司存在的问题：

1. 经手资金，内部猫腻多。存在圈钱跑路的风险。
2. 数据不公开透明，存在篡改风险。
一旦跑路还可能销毁数据库，使得证据缺失。
3. 流动性差，购买的债券只等等待到期兑现，没有一个市场进行转让

###区块链版本可以很好的解决上面的三个问题：

1. P2P公司不经手用户资金，用户资金完全和银行对接，和P2P公司无关。而且，用户资金冲入银行后，换成的比特人民币可以投资多家P2P公司。
2. 数据完全公开透明，P2P公司主要负责牵线搭桥，审核用户资料，无法凭空产生数据，也无法修改数据。
3. 有一个统一的债券转让市场，急用钱的时候可以在这里抛售转让。

