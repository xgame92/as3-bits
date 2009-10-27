package net.tw.util.air {
	import flash.data.*;
	import flash.events.*;
	import net.tw.util.Dynam;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class BaseObject {
		protected static var _baseData:Array=[];
		protected static var _q:SQLStatement;
		public static var defaultConnection:SQLConnection;
		//
		protected var _id:uint;
		protected var _data:Object={};
		//
		public function BaseObject(id:uint, tableData:TableData) {
			_id=id;
			Dynam.ize(this, tableData.fields, getter, setter);
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
		protected function setData(o:Object):void {
			_data=o;
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
			//trace(this, 'setter', key, val);
			q.clearParameters();
			q.text='UPDATE '+tableData.tableName+' SET '+key+'=@val WHERE id=@id';
			q.parameters['@val']=val;
			q.parameters['@id']=id;
			q.execute();
			_data[key]=val;
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
			if (!_baseData[tableName]) {
				_baseData[tableName]=[];
			}
			if (_baseData[tableName][id]) return _baseData[tableName][id];
			q.clearParameters();
			q.text='SELECT * FROM '+tableName+' WHERE id=@id';
			q.parameters['@id']=id;
			try {
				q.execute();
			} catch (e:Error) {
				trace('getFromID', tableData.asClass, e);
				return null;
			}
			//
			var o:BaseObject=new tableData.asClass(id);
			var res:SQLResult=q.getResult();
			if (res.data.length!=1) return null;
			//
			var d:Object=res.data[0];
			o.setData(d);
			_baseData[tableName][id]=o;
			return o;
		}
		public static function getFromID(id:uint):BaseObject {
			return null;
		}
		public static function getFromQuery(tableData:TableData, qs:String):Array {
			q.clearParameters();
			q.text=qs;
			try {
				q.execute();
			} catch (e:Error) {
				trace('getFromQuery', tableData.asClass, qs, e);
				return [];
			}
			//
			var ar:Array=[];
			var res:SQLResult=q.getResult();
			var data:Array=res.data;
			if (!data) return [];
			for (var i:uint=0; i<data.length; i++) {
				var d:Object=data[i];
				var o:BaseObject=new tableData.asClass(d.id);
				o.setData(d);
				ar.push(o);
			}
			return ar;
		}
		protected static function _exists(tableData:TableData, id:uint):Boolean {
			q.clearParameters();
			q.text='SELECT * FROM '+tableData.tableName+' WHERE id=@id';
			q.parameters['@id']=id;
			q.execute();
			//trace(q.text, id);
			var res:SQLResult=q.getResult();
			var d:Array=res.data;
			return d && d.length>0;
		}
		public static function exists(id:uint):Boolean {
			return false;
		}
		protected static function _create(tableData:TableData, data:Object):BaseObject {
			q.clearParameters();
			var qs:String='INSERT INTO '+tableData.tableName+' ';
			var fields:Array=[];
			var values:Array=[];
			if (data.id) {
				fields.push('id');
				values.push('@id');
				q.parameters['@id']=data.id;
			}
			for (var a:String in data) {
				if (tableData.fields.indexOf(a)==-1) continue;
				fields.push(a);
				values.push('@'+a);
				q.parameters['@'+a]=data[a];
			}
			qs+='('+fields.join(', ')+') VALUES ';
			qs+='('+values.join(', ')+')';
			q.text=qs;
			//trace(q.text, q.parameters);
			q.execute();
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
		public function toString():String {
			return '[BaseObject '+tableData.tableName+' '+id+']';
		}
	}
}