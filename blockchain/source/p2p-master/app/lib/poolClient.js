var mysql = require('mysql');

module.exports = Db;

function Db(config){

	this._pool = null;
	this.config = config;
	this._closed = false;
	this.state = true;


	this.applyDistinct = function(isdistinct, table, feilds, alias){
		var alias = arguments[3] ? arguments[3] : "t";
		if(feilds == "*"){
			var select = alias+".*";
		}else{
			var select = "";
			var tmp = feilds.split(',');
			for(var i=0; i<tmp.length; i++){
				if(i == 0){
					select += alias+"."+tmp[0];
				}else{
					select += ", " + alias+"."+tmp[i];
				}
			}
		}
		var sql = ((isdistinct === true) ? 'SELECT DISTINCT ':'SELECT ') + select + "  FROM " + table + " as " + alias + " ";
		return sql;
	}

	this.applyJoin = function(sql, join){
		if(join != ""){
			return sql+' '+join;
		}else{
			return sql;
		}
	}

	this.applyCondition = function(sql, condition){
		if(condition != ""){
			return sql+' WHERE '+condition;
		}else{
			return sql;
		}
	}

	this.applyGroup = function(sql, group){
		if(group != ""){
			return sql+' GROUP BY '+group;
		}else{
			return sql;
		}
	}

	this.applyHaving = function(sql, having){
		if(having != ""){
			return sql+' HAVING '+having;
		}else{
			return sql;
		}
	}

	this.applyOrder = function(sql, orderBy){
		if(orderBy != ""){
			return sql+' ORDER BY '+orderBy;
		}else{
			return sql;
		}
	}

	this.applyLimit = function(sql, limit, offset){
		if(limit > 0){
			sql +=  ' LIMIT ' + limit;
		}
		if(offset>0){
			sql +=  ' OFFSET ' + offset;
		}
		return sql;
	}

	this.getQuerySql = function(table, feilds, params){
		var sql = "";
		var that = this;
		var join = (params && typeof(params['join']) != 'undefined') ? params['join'] : "";
		var distinct = (params && typeof(params['distinct']) != 'undefined') ? params['distinct'] : false;
		var condition = (params && typeof(params['condition']) != 'undefined') ? params['condition'] : "";
		var group = (params && typeof(params['group']) != 'undefined') ? params['group'] : "";
		var having = (params && typeof(params['having']) != 'undefined') ? params['having'] : "";
		var order = (params && typeof(params['order']) != 'undefined') ? params['order'] : "";
		var limit = (params && typeof(params['limit']) != 'undefined') ? params['limit'] : 0;
		var offset = (params && typeof(params['offset']) != 'undefined') ? params['offset'] : 0;
		sql = that.applyDistinct(distinct, table, feilds);
		sql = that.applyJoin(sql,join);
		sql = that.applyCondition(sql,condition);
		sql = that.applyGroup(sql,group);
		sql = that.applyHaving(sql,having);
		sql = that.applyOrder(sql,order);
		sql = that.applyLimit(sql,limit,offset);
		return sql;
	}

	this.getInsertSql = function(table, params){
		var sql = "";
		var that = this;
		var keys = [];
		var vaules = "";
		if(params && typeof(params) == 'object'){
			var i = 0;
			for (key in params){
				keys[i] = key;
				vaules += "'" + params[key] + "',";
				i++;
			}
		}
		vaules  = vaules.substring(0, vaules.length-1);
		sql= "INSERT INTO " +table+ " ("+ keys.join(', ') + ') VALUES ('+ vaules +')';
		return sql;
	}

	this.getDeleteSql = function(table, params){
		var sql = "DELETE FROM " + table;
		var that = this;
		var join = (params && typeof(params['join']) != 'undefined') ? params['join'] : "";
		var condition = (params && typeof(params['condition']) != 'undefined') ? params['condition'] : "";
		var group = (params && typeof(params['group']) != 'undefined') ? params['group'] : "";
		var having = (params && typeof(params['having']) != 'undefined') ? params['having'] : "";
		var order = (params && typeof(params['order']) != 'undefined') ? params['order'] : "";
		var limit = (params && typeof(params['limit']) != 'undefined') ? params['limit'] : 0;
		var offset = (params && typeof(params['offset']) != 'undefined') ? params['offset'] : 0;
		sql = that.applyJoin(sql,join);
		sql = that.applyCondition(sql,condition);
		sql = that.applyGroup(sql,group);
		sql = that.applyHaving(sql,having);
		sql = that.applyOrder(sql,order);
		sql = that.applyLimit(sql,limit,offset);
		return sql;
	}

	this.getUpdateSql = function(table, data, params){
		var sql = "UPDATE " + table + " SET ";
		var that = this;
		var join = (params && typeof(params['join']) != 'undefined') ? params['join'] : "";
		var condition = (params && typeof(params['condition']) != 'undefined') ? params['condition'] : "";
		var order = (params && typeof(params['order']) != 'undefined') ? params['order'] : "";
		var limit = (params && typeof(params['limit']) != 'undefined') ? params['limit'] : 0;
		var offset = (params && typeof(params['offset']) != 'undefined') ? params['offset'] : 0;
		for(key in data){
			sql += key + "=" + "'" +data[key]+ "',";
		}
		sql  = sql.substring(0, sql.length-1);
		sql = that.applyJoin(sql,join);
		sql = that.applyCondition(sql,condition);
		sql = that.applyOrder(sql,order);
		sql = that.applyLimit(sql,limit,offset);
		return sql;
	}

	this.cb = function(result, params){
		//console.log(result);
		//console.log(params);
		return;
	}

}


Db.prototype.createPool = function(){
	if(!this.config){
		throw new Error("pool dbconfig is not set!");
	}else{
		if(!this._pool){
			this._pool = mysql.createPool(this.config);
		}
	}
}

Db.prototype.setReturnState = function(state){
	this.state = state;
}

Db.prototype.queryByManual = function(sql, cb){

}

Db.prototype.findOne = function(table, fields, cb, params){
	var that = this;
	var table = arguments[0] ? arguments[0] : "test";
	var fields = arguments[1] ? arguments[1] : "*";
	var cb = arguments[2] ? arguments[2] : that.cb;
	var params = arguments[3] ? arguments[3] : null;

	this._pool.getConnection(function(err, connection){
		if(err){
			that.handleError(err, connection);
		}else{
			var sql = that.getQuerySql(table, fields, params);
			connection.query(sql, function(err, rows) {
				if(err) throw err;
				if(rows.length <=0){
					cb([], params);
				}else{
					cb(rows[0], params);
				}
				connection.release();
			});
		}
	});
}

Db.prototype.query = function(table, fields, cb, params){
	var that = this;
	var table = arguments[0] ? arguments[0] : "test";
	var fields = arguments[1] ? arguments[1] : "*";
	var cb = arguments[2] ? arguments[2] : that.cb;
	var params = arguments[3] ? arguments[3] : null;

	this._pool.getConnection(function(err, connection){
		if(err){
			that.handleError(err, connection);
		}else{
			var sql = that.getQuerySql(table, fields, params);
			connection.query(sql, function(err, rows) {
				if(err) throw err;
				cb(rows, params);
				connection.release();
			});
		}
	});
}

Db.prototype.insert = function(table, fields, cb, params){
	var that = this;
	var table = arguments[0] ? arguments[0] : "test";
	var fields = arguments[1] ? arguments[1] : null;
	var cb = arguments[2] ? arguments[2] : that.cb;
	var params = arguments[3] ? arguments[3] : {};
	this._pool.getConnection(function(err, connection){
		if(err){
			that.handleError(err, connection);
		}else{
			var sql = that.getInsertSql(table, fields);
			connection.query(sql, function(err, result) {
				if(err) throw err;
				cb(result, params);
				connection.release();
			});
		}
	});
}


Db.prototype.delete = function(table, params, cb){
	var that = this;
	var table = arguments[0] ? arguments[0] : "test";
	var params = arguments[1] ? arguments[1] : null;
	var cb = arguments[2] ? arguments[2] : that.cb;
	this._pool.getConnection(function(err, connection){
		if(err){
			that.handleError(err, connection);
		}else{
			var sql = that.getDeleteSql(table, params);
			connection.query(sql, function(err, result) {
				if(err) throw err;
				cb(result, params);
				connection.release();
			});
		}
	});
}

Db.prototype.update = function(table, fields, cb, params){
	var that = this;
	var table = arguments[0] ? arguments[0] : "test";
	var fields = arguments[1] ? arguments[1] : null;
	var cb = arguments[2] ? arguments[2] : that.cb;
	var params = arguments[3] ? arguments[3] : null;

	this._pool.getConnection(function(err, connection){
		if(err){
			that.handleError(err, connection);
		}else{
			var sql = that.getUpdateSql(table, fields, params);
			connection.query(sql, function(err, rows) {
				if(err) throw err;
				cb(rows, params);
				connection.release();
			});
		}
	});
}

Db.prototype.handleError = function(err, connection){
	if(err){
		if(err.code === 'PROTOCOL_CONNECTION_LOST'){
			connection.connect();
		}else{
			console.error(err.stack || err);
			connection.release();
		}
	}
}

Db.prototype.end = function(){
	this._closed = true;
	if(!this._pool){
		this._pool.end();
	}
}