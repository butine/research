
function encrypt(text,key){
    return '' + CryptoJS.AES.encrypt(text,key);
}

function decrypt(cipher,key){
    var decrypted = CryptoJS.AES.decrypt(cipher,key);
    return decrypted.toString(CryptoJS.enc.Utf8);
}


