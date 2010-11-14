package net.tw.util.air {
	import flash.display.NativeWindow;
	import flash.display.Screen;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Point;
	
	import spark.components.Window;

	//
	public class WindowToolTip extends EventDispatcher {
		protected var _w:Window;
		protected var _s:Stage;
		protected var _offset:Point;
		//
		public static const SHOW:String='show';
		public static const SHOWING:String='showing';
		public static const HIDE:String='hide';
		public static const HIDING:String='hiding';
		public static const PLACE:String='place';
		public static const PLACING:String='placing';
		//
		public function WindowToolTip(w:Window, s:Stage) {
			_w=w;
			_s=s;
			_offset=new Point(10, 10);
			stage.nativeWindow.addEventListener(Event.CLOSING, closeWindow);
			stage.nativeWindow.addEventListener(Event.ACTIVATE, bringToFront);
			handleNativeWindowEvents();
		}
		protected function handleNativeWindowEvents():void {
			if (nativeWindow) nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, place);
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
			dispatchEvent(new Event(SHOWING));
			if (!nativeWindow) {
				window.open();
				handleNativeWindowEvents();
			}
			stage.addEventListener(MouseEvent.MOUSE_MOVE, place);
			dispatchEvent(new Event(SHOW));
			place(null, true);
		}
		public function hide():void {
			dispatchEvent(new Event(HIDING));
			if (nativeWindow) nativeWindow.visible=false;
			_s.removeEventListener(MouseEvent.MOUSE_MOVE, place);
			dispatchEvent(new Event(HIDE));
		}
		public function place(e:Event=null, doShow:Boolean=false):void {
			dispatchEvent(new Event(PLACING));
			//
			var dest:int=ScreenMouse.getX(stage)+offset.x;
			if (dest+nativeWindow.width>Screen.mainScreen.bounds.width) dest-=nativeWindow.width+2*offset.x;
			nativeWindow.x=dest;
			//
			dest=ScreenMouse.getY(stage)+offset.y;
			if (dest+nativeWindow.height>Screen.mainScreen.bounds.height) dest-=nativeWindow.height+2*offset.y;
			nativeWindow.y=dest;
			//
			if (nativeWindow.visible || doShow) {
				nativeWindow.visible=true;
				bringToFront();
			}
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