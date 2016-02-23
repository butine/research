var crypto = require('crypto'),
algorithm = 'aes-256-ctr',
async = require('async')

function encrypt(text,password){
    var cipher = crypto.createCipher(algorithm,password)
    var crypted = cipher.update(text,'utf8','hex')
    crypted += cipher.final('hex');
    return crypted;
}

function decrypt(text,password){
    var decipher = crypto.createDecipher(algorithm,password)
    var dec = decipher.update(text,'hex','utf8')
    dec += decipher.final('utf8');
    return dec;
}

function decryptAll(textArray,password,callback){
    async.map(textArray, 
	      function(text,cb){cb(null,decrypt(text,password));}, function (err, res) {
		  callback(res);
	      });
}

function sha256(text){
    return crypto.createHash('sha256').update(text).digest('hex');
}

// var hw = encrypt("hello world","password");
// console.log(decrypt(hw,"password"));
// decryptAll([hw,hw,hw],"password",console.log);
// console.log(sha256('password'));

exports.encrypt = encrypt
exports.decrypt = decrypt
exports.decryptAll = decryptAll
exports.sha256 = sha256
