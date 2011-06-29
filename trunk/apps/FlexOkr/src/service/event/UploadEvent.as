package service.event {
	import flash.events.Event;
	public class UploadEvent extends Event {
		public static const UPLOAD_SUCCESS:String='service.event.UploadEvent.UPLOAD_SUCCESS';
		public static const UPLOAD_ERROR:String='service.event.UploadEvent.UPLOAD_ERROR';
		protected var _data:String;
		public function UploadEvent(type:String, $data:String='', bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_data=$data;
		}
		public function get data():String {
			return _data;
		}
		override public function clone():Event {
			return new UploadEvent(type, data, bubbles, cancelable);
		}
		override public function toString():String {
			return formatToString('UploadEvent', 'type', 'bubbles', 'cancelable', 'data');
		}
	}
}