package net.tw.util.air {
	import flash.data.*;
	import flash.events.*;
	import net.tw.util.air.events.BaseObjectEvent;
	import net.tw.util.Dynam;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class BaseObject extends EventDispatcher {
		protected static var _baseData:Array=[];
		protected static var _q:SQLStatement;
		//
		public static var defaultConnection:SQLConnection;
		//
		protected var _id:uint;
		protected var _data:Object={};
		protected var _cache:Object={};
		protected var _populated:Boolean=false;
		//
		public function BaseObject(id:uint, tableData:TableData) {
			_id=id;
			Dynam.ize(this, tableData.fields, getter, setter);
			store(tableData.tableName, id, this);
		}
		public function get id():uint {
			return _id;
		}
		public static function get q():SQLStatement {
			if (!_q) {
				_q=new SQLStatement();
				_q.sqlConnection=defaultConnection;
				//_q.addEventListener(SQLErrorEvent.ERROR, onQueryError);
			}
			return _q;
		}
		/*static private function onQueryError(e:SQLEvent):void {
			trace('SQL Error!', e.type);
		}*/
		protected function populate(o:Object):void {
			_data=o;
			_populated=true;
		}
		public function get tableData():TableData {
			return new TableData();
		}
		protected function getter(key:String):* {
			return _data[key];
		}
		protected function setter(key:String, val:*):void {
			if (!valIsDifferent(key, val)) return;
			execQuery('UPDATE '+tableData.tableName+' SET '+key+'=@val WHERE id=@id', {'@val':val, '@id':id});
			_data[key]=val;
			//
			if (_populated) dispatchEvent(new BaseObjectEvent(BaseObjectEvent.CHANGE, key));
		}
		protected function valIsDifferent(key:String, val:*):Boolean {
			var curVal:*=_data[key];
			if (curVal==val) return false;
			if (curVal is Date) {
				var d:Date=curVal as Date;
				var valDate:Date=dateString2date(val);
				return valDate.toString()!=curVal.toString();
			}
			return true;
		}
		public function setField(key:String, val:*):void {
			setter(key, val);
		}
		public function getField(key:String):* {
			return getter(key);
		}
		public static function dateString2date(s:String):Date {
			// 2009-01-11 16:04:05
			var ar:Array=s.split(' ');
			var arD:Array=ar[0].split('-');
			var arT:Array=ar[1].split(':');
			return new Date(arD[0], int(arD[1])-1, arD[2], arT[0], arT[1], arT[2]);
		}
		protected static function _getFromID(tableData:TableData, id:uint):BaseObject {
			var tableName:String=tableData.tableName;
			if (!_baseData[tableName]) _baseData[tableName]=[];
			if (_baseData[tableName][id]) return _baseData[tableName][id];
			prepareQuery('SELECT * FROM '+tableName+' WHERE id=@id', {'@id':id});
			try {
				var res:SQLResult=execQuery();
			} catch (e:Error) {
				trace(e, 'getFromID', tableData.asClass);
				return null;
			}
			//
			if (res.data.length!=1) return null;
			//
			var o:BaseObject=new tableData.asClass(id);
			var d:Object=res.data[0];
			o.populate(d);
			return o;
		}
		public static function getFromID(id:uint):BaseObject {
			return null;
		}
		protected static function _getFromQuery(tableData:TableData, qs:String, params:Object=null):Array {
			prepareQuery(qs, params);
			try {
				var res:SQLResult=execQuery();
			} catch (e:Error) {
				trace(e, 'getFromQuery', tableData.asClass, qs);
				return [];
			}
			//
			var ar:Array=[];
			var data:Array=res.data;
			if (!data) return [];
			for (var i:uint=0; i<data.length; i++) {
				var d:Object=data[i];
				if (isStored(tableData.tableName, d.id)) {
					ar.push(_baseData[tableData.tableName][d.id]);
				} else {
					var o:BaseObject=new tableData.asClass(d.id);
					o.populate(d);
					ar.push(o);
				}
			}
			return ar;
		}
		public static function getFromQuery(tableData:TableData, qs:String, params:Object=null):Array {
			return [];
		}
		protected static function isStored(tableName:String, id:uint):Boolean {
			return _baseData[tableName] && _baseData[tableName][id];
		}
		protected static function store(tableName:String, id:uint, o:BaseObject):void {
			if (!_baseData[tableName]) _baseData[tableName]=[];
			_baseData[tableName][id]=o;
		}
		protected static function _exists(tableData:TableData, id:uint):Boolean {
			var res:SQLResult=execQuery('SELECT * FROM '+tableData.tableName+' WHERE id=@id', {'@id':id});
			var d:Array=res.data;
			return d && d.length>0;
		}
		public static function exists(id:uint):Boolean {
			return false;
		}
		protected static function _create(tableData:TableData, data:Object):BaseObject {
			var qs:String='INSERT INTO '+tableData.tableName+' ';
			//
			var fields:Array=[];
			var values:Array=[];
			var params:Object={};
			//
			if (data.id) {
				fields.push('id');
				values.push('@id');
				params['@id']=data.id;
			}
			for (var a:String in data) {
				if (tableData.fields.indexOf(a)==-1) continue;
				fields.push(a);
				values.push('@'+a);
				params['@'+a]=data[a];
			}
			//
			qs+='('+fields.join(', ')+') VALUES ';
			qs+='('+values.join(', ')+')';
			//
			execQuery(qs, params);
			//
			var idq:String=data.id ? data.id : '(SELECT MAX(id) FROM '+tableData.tableName+')';
			return _getFromQuery(tableData, 'SELECT * FROM '+tableData.tableName+' WHERE id='+idq)[0];
		}
		public static function create(data:Object):BaseObject {
			return null;
		}
		public function update(data:Object):void {
			var qs:String='UPDATE '+tableData.tableName+' SET ';
			var params:Object={};
			var fields:Array=[];
			//
			for (var a:String in data) {
				if (tableData.fields.indexOf(a)==-1) continue;
				if (a=='id') continue;
				if (!valIsDifferent(a, data[a])) continue;
				//
				params['@'+a]=data[a];
				if (fields.length>0) qs+=', ';
				qs+=a+'=@'+a;
				fields.push(a);
				//
				_data[a]=data[a];
			}
			if (fields.length==0) return;
			//
			qs+=' WHERE id=@id;';
			params['@id']=id;
			execQuery(qs, params);
			for (var i:uint=0; i<fields.length; i++) dispatchEvent(new BaseObjectEvent(BaseObjectEvent.CHANGE, fields[i]));
		}
		public function dispose():void {
			execQuery('DELETE FROM '+tableData.tableName+' WHERE id=@id', {'@id':id});
			dispatchEvent(new BaseObjectEvent(BaseObjectEvent.DISPOSE));
		}
		public static function cinch(tableData:TableData, id:uint, data:Object):BaseObject {
			var o:BaseObject;
			if (!tableData.asClass.exists(id)) {
				o=tableData.asClass.create(data);
			} else {
				o=tableData.asClass.getFromID(id);
				o.update(data);
			}
			return o;
		}
		//
		protected static function prepareQuery(qs:String, params:Object=null):void {
			q.text=qs;
			q.clearParameters();
			if (params) for (var a:String in params) q.parameters[a]=params[a];
		}
		public static function execQuery(qs:String=null, params:Object=null):SQLResult {
			if (qs) prepareQuery(qs, params);
			q.execute();
			return q.getResult();
		}
		//
		protected function hasCache(key:String):Boolean {
			return _cache.hasOwnProperty(key);
		}
		protected function deleteCache(key:String):Boolean {
			return delete _cache[key];
		}
		protected function getCache(key:String):* {
			return _cache[key];
		}
		protected function setCache(key:String, val:*):* {
			_cache[key]=val;
			return val;
		}
		//
		override public function toString():String {
			return '[BaseObject '+tableData.tableName+' '+id+']';
		}
	}
}