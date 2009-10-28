package net.tw.util.air.events {
	import flash.events.Event;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class BaseObjectChangeEvent extends Event {
		public static const CHANGE:String='change';
		public var changedField:String;
		public function BaseObjectChangeEvent(type:String, field:String) {
			changedField=field;
			super(type);
		}
	}
}