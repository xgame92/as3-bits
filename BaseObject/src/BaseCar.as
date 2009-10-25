package  {
	import net.tw.util.air.BaseObject;
	import net.tw.util.air.TableData;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public dynamic class BaseCar extends BaseObject {
		protected static var _tableData:TableData;
		public function BaseCar(id:uint) {
			super(id, tableData);
		}
		override public function get tableData():TableData {
			return getTableData();
		}
		public static function getTableData():TableData {
			if (!_tableData) _tableData=new TableData('car', BaseCar, ['name', 'brand', 'speed', 'clientID', 'purchaseDate']);
			return _tableData;
		}
		public static function getFromID(id:uint):BaseCar {
			return BaseObject.getFromID(getTableData(), id) as BaseCar;
		}
		public static function getFromQuery(qs:String):Array {
			return BaseObject.getFromQuery(getTableData(), qs);
		}
		//
		public function getClient():BaseClient {
			return BaseClient.getFromID(this.getClientID());
		}
	}
}