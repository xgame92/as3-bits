package  {
	import flash.data.SQLStatement;
	import net.tw.util.air.BaseObject;
	import net.tw.util.air.TableData;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public dynamic class BaseClient extends BaseObject {
		protected static var _tableData:TableData;
		public function BaseClient(id:uint) {
			super(id, tableData);
		}
		override public function get tableData():TableData {
			return getTableData();
		}
		public static function getTableData():TableData {
			if (!_tableData) _tableData=new TableData('client', BaseClient, ['name', 'url', 'male']);
			return _tableData;
		}
		public static function getFromID(id:uint):BaseClient {
			return BaseObject._getFromID(getTableData(), id) as BaseClient;
		}
		public static function getFromQuery(qs:String):Array {
			return BaseObject._getFromQuery(getTableData(), qs);
		}
		public function getCars(force:Boolean=false):Array {
			//return BaseCar.getFromQuery('SELECT * FROM car WHERE clientID='+id);
			return (hasCache('cars') && !force) ? getCache('cars') : setCache('cars', BaseCar.getFromQuery('SELECT * FROM car WHERE clientID='+id));
		}
	}
}