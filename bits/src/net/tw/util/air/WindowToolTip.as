package net.tw.util.air {
	import spark.components.Window;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.display.NativeWindow;
	import flash.display.Screen;
	import flash.events.EventDispatcher;
	//
	public class WindowToolTip extends EventDispatcher {
		protected var _w:Window;
		protected var _s:Stage;
		protected var _offset:Point;
		//
		public static const SHOW:String='show';
		public static const HIDE:String='hide';
		public static const PLACE:String='place';
		//
		public function WindowToolTip(w:Window, s:Stage) {
			_w=w;
			_s=s;
			_offset=new Point(10, 10);
			stage.nativeWindow.addEventListener(Event.CLOSING, closeWindow);
			stage.nativeWindow.addEventListener(Event.ACTIVATE, bringToFront);
		}
		public function get window():Window {
			return _w;
		}
		public function get nativeWindow():NativeWindow {
			return window.nativeWindow;
		}
		public function get stage():Stage {
			return _s;
		}
		public function get offset():Point {
			return _offset;
		}
		public function show():void {
			if (!nativeWindow) window.open();
			dispatchEvent(new Event(SHOW));
			stage.addEventListener(MouseEvent.MOUSE_MOVE, place);
			place();
		}
		public function hide():void {
			nativeWindow.visible=false;
			dispatchEvent(new Event(HIDE));
			_s.removeEventListener(MouseEvent.MOUSE_MOVE, place);
		}
		protected function place(e:Event=null):void {
			var dest:int=ScreenMouse.getX(stage)+offset.x;
			if (dest+nativeWindow.width>Screen.mainScreen.bounds.width) dest-=nativeWindow.width+2*offset.x;
			nativeWindow.x=dest;
			//
			dest=ScreenMouse.getY(stage)+offset.y;
			if (dest+nativeWindow.height>Screen.mainScreen.bounds.height) dest-=nativeWindow.height+2*offset.y;
			nativeWindow.y=dest;
			//
			if (!nativeWindow.visible) nativeWindow.visible=true;
			bringToFront();
			dispatchEvent(new Event(PLACE));
		}
		protected function bringToFront(e:Event=null):void {
			if (nativeWindow && nativeWindow.visible) nativeWindow.orderToFront();
		}
		protected function closeWindow(e:Event=null):void {
			window.close();
		}
	}
}