package net.tw.util.air.events {
	import flash.events.Event;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class BaseObjectEvent extends Event {
		public static const CHANGE:String='baseObjectChange';
		public static const DISPOSE:String='baseObjectDispose';
		public var changedField:String;
		public function BaseObjectEvent(type:String, field:String=null) {
			changedField=field;
			super(type);
		}
	}
}