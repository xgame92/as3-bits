package data {
	import mx.collections.ArrayCollection;
	import spark.components.List;
	import spark.components.NavigatorContent;
	//
	public class TabData {
		protected var _ac:ArrayCollection;
		protected var _nc:NavigatorContent;
		protected var _lst:spark.components.List;
		//
		public function TabData(pac:ArrayCollection, pnc:NavigatorContent, plst:List) {
			_ac=pac;
			_nc=pnc;
			_lst=plst;
		}
		public function get ac():ArrayCollection {
			return _ac;
		}
		public function get nc():NavigatorContent {
			return _nc;
		}
		public function get lst():List {
			return _lst;
		}
	}
}