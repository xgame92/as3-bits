package net.tw.util.air.events {
	import flash.events.Event;
	public class AIRAppManagerEvent extends Event {
		public static const CONFIG_GOT:String='net.tw.util.air.events.AIRAppManagerEvent.CONFIG_GOT';
		public function AIRAppManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		override public function clone():Event {
			return new AIRAppManagerEvent(type, bubbles, cancelable);
		}
		override public function toString():String {
			return formatToString('AIRAppManagerEvent', 'type', 'bubbles', 'cancelable');
		}
	}
}