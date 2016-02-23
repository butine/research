var express = require('express');
var Async = require('async');
var fs = require('fs');
var path = require('path');
var http = require('http');
var routes = require('./routes');
var ejs = require('ejs');
var favicon = require('serve-favicon');
var methodOverride = require('method-override');
var cookieParser = require('cookie-parser');
var session = require('express-session');
var bodyParser = require('body-parser');
//var web3 = new Web3();
//web3.setProvider(new web3.providers.HttpProvider("http://localhost:8545"));
//var BlockObject = require('./lib/block.js');
//var Block = new BlockObject(web3);


var app = express();
app.use(methodOverride());
app.use(bodyParser());
app.use(cookieParser());
app.use(session({ 
    secret: 'rtyryr', 
    key: 'sid', 
    cookie: { secure: false }
}))
app.use(express.static(path.join(__dirname, 'public')));
app.set('port', process.env.PORT || 3000); 
app.set('views', __dirname + '/views');
app.set('source', __dirname + '/source');
app.engine('.html', ejs.__express);
app.set('view engine', 'html');
app.set('fs', fs);



app.all('*', function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    res.header("Access-Control-Allow-Methods","PUT,POST,GET,DELETE,OPTIONS");
    if(req.method=="OPTIONS") res.send(200);
    next();
});


routes(app);


var server = app.listen(app.get('port'), function () {
	console.log('The server is runing.......');
});
