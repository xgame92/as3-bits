package net.tw.util.air {
	import flash.data.*;
	import flash.events.*;
	import net.tw.util.air.events.BaseObjectEvent;
	import net.tw.util.Dynam;
	import mx.utils.ObjectUtil;
	import flash.net.Responder;

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
			var curVal:*=_data[key];
			if (curVal==val) return;
			if (curVal is Date) {
				var d:Date=curVal as Date;
				var valDate:Date=dateString2date(val);
				if (valDate.toString()==curVal.toString()) return; 
			}
			execQuery('UPDATE '+tableData.tableName+' SET '+key+'=@val WHERE id=@id', {'@val':val, '@id':id});
			_data[key]=val;
			//
			if (_populated) dispatchEvent(new BaseObjectEvent(BaseObjectEvent.CHANGE, key));
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
		public static function getFromQuery(tableData:TableData, qs:String):Array {
			prepareQuery(qs);
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
				//if (t) trace(i, ObjectUtil.toString(d));
				//var t:Boolean=d.id==34 && tableData.tableName=='software';
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
			return getFromQuery(tableData, 'SELECT * FROM '+tableData.tableName+' WHERE id='+idq)[0];
		}
		public static function create(data:Object):BaseObject {
			return null;
		}
		public function update(data:Object):void {
			for (var a:String in data) {
				if (tableData.fields.indexOf(a)==-1) continue;
				if (a=='id') continue;
				setter(a, data[a]);
			}
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
		/*protected static var _openReference:Object;
		protected static var _asyncQS:String;
		protected static var _asyncParams:Object;
		protected static var _autoReconnect:Boolean;
		protected static var _isSync:Boolean=true;
		public static function switchToSync(b:Boolean, openReference:Object):void {
			if (b==_isSync) return;
			_isSync=b;
			_openReference=openReference;
			defaultConnection.close(new Responder(onConClose));
		}
		protected static function onConClose(res:*):void {
			trace('onConClose', res);
			defaultConnection=new SQLConnection();
			defaultConnection.addEventListener(SQLEvent.OPEN, onSwitchOpen);
			_isSync ? defaultConnection.open(_openReference) : defaultConnection.openAsync(_openReference);
		}
		protected static function onSwitchOpen(e:SQLEvent):void {
			trace('asyncOpen', e);
			defaultConnection.removeEventListener(SQLEvent.OPEN, onSwitchOpen);
			var s:SQLStatement=new SQLStatement();
			s.text=_asyncQS;
			if (_asyncParams) for (var a:String in _asyncParams) s.parameters[a]=_asyncParams[a];
			s.addEventListener(SQLEvent.RESULT, onAsyncRes);
			s.execute();
		}
		public static function execQueryAsync(openReference:Object, qs:String, params:Object=null, autoReconnect:Boolean=true):void {
			_openReference=openReference;
			_asyncQS=qs;
			_asyncParams=params;
			_autoReconnect=autoReconnect;
			defaultConnection.close(new Responder(onConClose));
		}
		protected static function onAsyncRes(e:SQLEvent):void {
			trace('asyncRes', e);
			if (_autoReconnect) {
				defaultConnection.close();
				defaultConnection.open(_openReference);
			}
		}*/
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