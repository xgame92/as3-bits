package  {
	import flash.data.SQLStatement;
	import net.tw.util.air.BaseObject;
	import net.tw.util.air.TableData;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public dynamic class Client extends BaseObject {
		protected static var _tableData:TableData;
		public function Client(id:uint) {
			super(id, tableData);
		}
		override public function get tableData():TableData {
			return getTableData();
		}
		public static function getTableData():TableData {
			if (!_tableData) _tableData=new TableData('client', Client, ['name', 'url', 'male']);
			return _tableData;
		}
		public static function getFromID(id:uint):Client {
			return BaseObject._getFromID(getTableData(), id) as Client;
		}
		public static function getFromQuery(qs:String, params:Object=null):Array {
			return BaseObject._getFromQuery(getTableData(), qs, params);
		}
		public static function create(data:Object):Client {
			return BaseObject._create(getTableData(), data) as Client;
		}
		public function getCars(force:Boolean=false):Array {
			return (hasCache('cars') && !force) ?
				getCache('cars') :
				setCache('cars', Car.getFromQuery('SELECT * FROM car WHERE clientID=@id', {'@id':id}));
		}
	}
}