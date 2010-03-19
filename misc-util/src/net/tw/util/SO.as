package net.tw.util {
	import flash.net.SharedObject;
	//
	public class SO {
		protected static var so:SharedObject;
		{
			so=SharedObject.getLocal('net.tw.util.SO');
		}
		public function SO() {}
		public static function getItem(name:String):* {
			if (!hasItem(name)) return null;
			return so.data[name];
		}
		public static function hasItem(name:String):Boolean {
			if (!so) return false;
			return so.data.hasOwnProperty(name);
		}
		public static function setItem(name:String, data:*, pFlush:Boolean=true):Boolean {
			if (!so) return false;
			so.data[name]=data;
			if (pFlush) so.flush();
			return true;
		}
		public static function flush():void {
			if (so) so.flush();
		}
		public static function clear():Boolean {
			if (!so) return false;
			so.clear();
			return true;
		}
	}
}