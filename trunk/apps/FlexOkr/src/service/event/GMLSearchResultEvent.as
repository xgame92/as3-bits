package service.event {
	import flash.events.Event;
	
	public class GMLSearchResultEvent extends Event {
		protected var _results:Array;
		public static const RESULTS_READY:String='RESULTS_READY';
		public function GMLSearchResultEvent(type:String, $results:Array, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_results=$results;
		}
		public function get results():Array {
			return _results;
		}
		override public function clone():Event {
			return new GMLSearchResultEvent(type, results, bubbles, cancelable);
		}
	}
}