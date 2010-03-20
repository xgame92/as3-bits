package net.tw.util.air {
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class TableData {
		public var tableName:String;
		public var asClass:Class;
		public var fields:Array;
		public function TableData(tn:String=null, cl:Class=null, f:Array=null) {
			tableName=tn;
			asClass=cl;
			fields=f;
		}
	}
}