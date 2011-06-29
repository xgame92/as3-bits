package view.event {
	import flash.events.Event;
	
	public class DrawActionEvent extends Event {
		public static const DONE:String='DONE';
		public static const CLEAR:String='CLEAR';
		public static const SUBMIT:String='SUBMIT';
		public static const UPLOAD:String='UPLOAD';
		//
		/*protected var _gml:XML;
		protected var _keywords:String;
		protected var _appName:String;*/
		//
		public function DrawActionEvent(type:String, /*$keywords:String='', $gml:XML=null, $appName:String='', */bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			/*_gml=$gml;
			_keywords=$keywords;
			_appName=$appName;*/
		}
		/*public function get keywords():String {
			return _keywords;
		}
		public function get appName():String {
			return _appName;
		}
		public function get gml():XML {
			return _gml;
		}*/
		override public function clone():Event {
			return new DrawActionEvent(type,/* keywords, gml, appName, */bubbles, cancelable);
		}
	}
}