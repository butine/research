var zerorpc = require('zerorpc');
var client = new zerorpc.Client();
client.connect("tcp://127.0.0.1:4242");


var express = require('express');
var qr = require('./qr.js');
var utils = require('./utils.js');
var bodyParser = require("body-parser");
var app = express();

app.use(bodyParser.json()); // for parsing application/json
app.use(bodyParser.urlencoded({ extended: true })); // for parsing application/x-www-form-urlencoded


app.get('/', function (req, res) {
  res.send('Hello World!');
});

app.get('/login/:id',function(req,res){
    var id = req.params.id;
    client.invoke("login",id,function(err,result,more) {
	res.jsonp({
	    'id':id,
	    'entries':result
	});
    });
})

app.get('/showaddr',function(req,res){
    client.invoke("showAddress",function(err,result,more){
	res.jsonp(result);	    
    });
})

app.get('/query/:id/:hash',function(req,res) {
    client.invoke("query",req.params.id,req.params.hash,function(err,result,more){
	res.jsonp({'result':result});
    });
});

app.post('/append',function(req,res) {
    var ID = req.body.id;
    var Cipher = req.body.encrypted;
    console.log(Cipher);
    client.invoke("append",ID,Cipher,function(err,result,more){
	res.json({'result':result});
    })
});

app.get('/hello',function(req,res){
    res.json({ 'user':'test-user',
	       'age':60,
	       'data':'balahbalah'
	     });
});

app.get('/user/:id',function(req,res){
    res.json({ 'id':req.params.id,
	       'data':'testdata'
	     });
});


function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

app.get('/detail/:id',function(req,res){
    res.json({ 'data': [getRandomInt(0,5),getRandomInt(0,5),getRandomInt(0,5),getRandomInt(0,5),getRandomInt(0,5)] });
});

app.get('/getQR', function(req,res) {
    data = req.query.data;
    if (data!=null) {
	qr.genQRCode(data,function(base64){
	    var imageData = utils.decodeBase64Image(base64);
console.log(imageData);
	    res.writeHead(200, {'Content-Type': 'image/png' });
	    res.end(imageData.data, 'binary');
	});
    } else {
	res.send("");
    }
});

app.listen(3000,function(){
    console.log("Started");
});
