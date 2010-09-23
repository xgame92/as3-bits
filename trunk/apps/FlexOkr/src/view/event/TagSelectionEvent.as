package view.event {
	import flash.events.Event;
	
	public class TagSelectionEvent extends Event {
		protected var _id:String;
		public static const SELECT:String='SELECT';
		public function TagSelectionEvent(type:String, $id:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_id=$id;
		}
		public function get id():String {
			return _id;
		}
		override public function clone():Event {
			return new TagSelectionEvent(type, id, bubbles, cancelable);
		}
	}
}