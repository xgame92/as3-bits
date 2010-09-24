package net.tw.flex.mx.util {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.managers.SystemManager;

	public class LazyPopUpCloser {
		protected static var _popup:IFlexDisplayObject;
		protected static var _stage:Stage;
		public static function set popup($popup:IFlexDisplayObject):void {
			_popup=$popup;
			if ($popup) {
				_stage=_popup.stage;
				_stage.addEventListener(MouseEvent.CLICK, onStageClick);
			} else if (_stage) {
				_stage.removeEventListener(MouseEvent.CLICK, onStageClick);
			}
		}
		public static function get popup():IFlexDisplayObject {
			return _popup;
		}
		protected static function onStageClick(e:MouseEvent):void {
			var tg:DisplayObject=e.target as DisplayObject;
			if (tg.name=='modalWindow' && tg.parent is SystemManager) {
				_popup.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
			}
		}
	}
}