package view.event {
	import flash.events.Event;
	
	public class InkSettingEvent extends Event {
		protected var _minSize:Number;
		protected var _maxSize:Number;
		protected var _drips:Number;
		//
		public static const CHANGE:String='CHANGE';
		//
		public function InkSettingEvent(type:String, $minSize:Number, $maxSize:Number, $drips:Number, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_minSize=$minSize;
			_maxSize=$maxSize;
			_drips=$drips;
		}
		public function get minSize():Number {
			return _minSize;
		}
		public function get maxSize():Number {
			return _maxSize;
		}
		public function get drips():Number {
			return _drips;
		}
		override public function clone():Event {
			return new InkSettingEvent(type, minSize, maxSize, drips, bubbles, cancelable);
		}
	}
}