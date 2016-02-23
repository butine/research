var QRCode = require('qrcode');

function genQRCode(data,callback) {
    QRCode.toDataURL('i am a pony!',function(err,url){
	callback(url);
    });
}

exports.genQRCode = genQRCode;
