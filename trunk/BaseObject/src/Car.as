package {
	import net.tw.util.air.BaseObject;
	import net.tw.util.air.TableData;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public dynamic class Car extends BaseObject {
		protected static var _tableData:TableData;
		public function Car(id:uint) {
			super(id, tableData);
		}
		override public function get tableData():TableData {
			return getTableData();
		}
		public static function getTableData():TableData {
			if (!_tableData) _tableData=new TableData('car', Car, ['name', 'brand', 'speed', 'clientID', 'purchaseDate']);
			return _tableData;
		}
		public static function getFromID(id:uint):Car {
			return BaseObject._getFromID(getTableData(), id) as Car;
		}
		public static function getFromQuery(qs:String, params:Object=null):Array {
			return BaseObject._getFromQuery(getTableData(), qs, params);
		}
		public function getClient():Client {
			return Client.getFromID(this.getClientID());
		}
	}
}