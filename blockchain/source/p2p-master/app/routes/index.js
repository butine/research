//var bank = require("./bank");


module.exports = function(app){
	
	//bank(app);

	app.get('/', function(req, res) {
		res.render('register');
	});

	app.all('/getBalance/:coin', function(req, res) {
		  var coin = req.params.coin;
		  var Block = app.get('Block');
		  var balance = Block.getBalance(coin);
		  res.json({balance: balance.toNumber()})

	});

	app.all('/coin', function(req, res) {
		res.render('coin');  
	});

	app.all('/coin2', function(req, res) {
		res.render('coin2');  
	});

	app.all('/apply', function(req, res) {
		res.render('apply');  
	});

	app.all('/list', function(req, res) {
		res.render('list');  
	});

	app.get('/home', function(req, res) {
		res.render('home');  
	});

	app.get('/bankapply', function(req, res) {
		res.render('bankapply');  
	});

	app.get('/bankorder', function(req, res) {
		res.render('bankorder');  
	});

	app.all('/detail/:id', function(req, res) {
		var trade_id = req.params.id;
		res.render('details', {trade_id: trade_id});  
	});

	app.all('/myaccount', function(req, res) {
		res.render('mybuy');
	});

	app.all('/register', function(req, res) {
		res.render('register');
	});

	app.all('/check', function(req, res) {
		res.render('check');
	});

	app.get('/verifyuserinfo', function(req, res) {
		res.render('verifyuserinfo');  
	});

	app.get('/verifylist', function(req, res) {
		res.render('verifylist');  
	});

	app.get('/tradebuy', function(req, res) {
		res.render('tradebuy');  
	});

	app.get('/tradesell', function(req, res) {
		res.render('tradesell');  
	});

	
	app.get('/mybuy', function(req, res) {
		res.render('mybuy');  
	});

	app.get('/mysell', function(req, res) {
		res.render('mysell');  
	});	
};


