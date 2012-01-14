package net.tw.util {
	import flash.net.SharedObject;

	public class SharedObjectWrapper {
		
		protected var _so:SharedObject;
		
		public function SharedObjectWrapper(name:String, localPath:String=null, secure:Boolean=false) {
			_so=SharedObject.getLocal(name, localPath, secure);
		}
		public function get sharedObject():SharedObject {
			return _so;
		}
		public function hasItem(key:String):Boolean {
			if (!_so) return false;
			return _so.data.hasOwnProperty(key);
		}
		public function getItem(key:String):* {
			if (!hasItem(key)) return null;
			return _so.data[key];
		}
		public function setItem(key:String, data:*, $flush:Boolean=true):Boolean {
			if (!_so) return false;
			_so.data[key]=data;
			if ($flush) _so.flush();
			return true;
		}
		public function flush():void {
			if (_so) _so.flush();
		}
		public function clear():Boolean {
			if (!_so) return false;
			_so.clear();
			return true;
		}
		
		// Methods for easy acces if SharedObject only manages one item
		public function get mainKey():String {
			return 'MAIN_KEY';
		}
		public function set mainItem(data:*):void {
			setItem(mainKey, data);
		}
		public function get mainItem():* {
			return getItem(mainKey);
		}
		public function get hasMainItem():Boolean {
			return hasItem(mainKey);
		}
	}
}