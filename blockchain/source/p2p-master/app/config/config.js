var config = {
	pooldb : {
		host : "127.0.0.1",
		user : "root",
		password : "123456",
		database : "blockchain",
		connectionLimit : 1000,
		port:3306,
		queueLimit:1000,
		connectTimeout: 1000000,
		acquireTimeout: 1000000
	}
};

module.exports = config;

