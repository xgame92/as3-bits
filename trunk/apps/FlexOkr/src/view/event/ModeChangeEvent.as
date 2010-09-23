package view.event
{
	import flash.events.Event;
	
	public class ModeChangeEvent extends Event {
		public static const MODE_CHANGE:String='MODE_CHANGE';
		public static const PLAY_MODE:String='PLAY_MODE';
		public static const DRAW_MODE:String='DRAW_MODE';
		protected var _mode:String;
		public function ModeChangeEvent(type:String, $mode:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_mode=$mode;
		}
		public function get mode():String {
			return _mode;
		}
		override public function clone():Event {
			return new ModeChangeEvent(type, mode, bubbles, cancelable);
		}
	}
}