package net.tw.flex.spark.components.events {
	import flash.events.Event;
	public class ClippedImageSourceChangeEvent extends Event {

		public static const SOURCE_CHANGED:String='sourceChanged';

		public function ClippedImageSourceChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		override public function clone():Event {
			return new ClippedImageSourceChangeEvent(type, bubbles, cancelable);
		}
		override public function toString():String {
			return formatToString('ClippedImageSourceChangeEvent', 'type', 'bubbles', 'cancelable');
		}
	}
}