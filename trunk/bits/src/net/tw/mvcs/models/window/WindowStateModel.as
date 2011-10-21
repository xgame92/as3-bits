package net.tw.mvcs.models.window {
	import flash.display.NativeWindow;
	import flash.display.NativeWindowDisplayState;
	import flash.display.Screen;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	
	import net.tw.mvcs.models.window.vo.WindowState;
	import net.tw.util.SO;

	public class WindowStateModel implements IWindowStateModel {
		
		public static const KEY_PREFIX:String='net.tw.mvcs.models.window.WindowStateModel.KEY_PREFIX.';
		protected static const _instances:Dictionary=new Dictionary();
		
		{
			registerClassAlias('net.tw.mvcs.models.window.vo.WindowState', WindowState);
		}
		
		public function WindowStateModel($nativeWindow:NativeWindow, $keySuffix:String='main'):void {
			_nativeWindow=$nativeWindow;
			_keySuffix=$keySuffix;
			
			_instances[$nativeWindow]=this;
		}
		public static function storeWindowState(nw:NativeWindow):Boolean {
			if (!_instances[nw]) return false;
			return (_instances[nw] as WindowStateModel).store();
		}
		public static function restoreWindowState(nw:NativeWindow):Boolean {
			if (!_instances[nw]) return false;
			return (_instances[nw] as WindowStateModel).restore();
		}
		protected var _nativeWindow:NativeWindow;
		public function get nativeWindow():NativeWindow {
			return _nativeWindow;
		}
		protected var _keySuffix:String;
		public function get keySuffix():String {
			return _keySuffix;
		}
		public function get key():String {
			return KEY_PREFIX+keySuffix;
		}
		public function store():Boolean {
			var ws:WindowState=new WindowState();
			
			ws.boundsX=nativeWindow.bounds.x;
			ws.boundsY=nativeWindow.bounds.y;
			ws.boundsWidth=nativeWindow.bounds.width;
			ws.boundsHeight=nativeWindow.bounds.height;
			
			ws.displayState=nativeWindow.displayState;
			
			return SO.setItem(key, ws);
		}
		public function restore():Boolean {
			var ws:WindowState=SO.getItem(key);
			if (ws is WindowState) {
				if (ws.displayState==NativeWindowDisplayState.MAXIMIZED) {
					nativeWindow.maximize();
					return true;
				}
				var bounds:Rectangle=new Rectangle(ws.boundsX, ws.boundsY, ws.boundsWidth, ws.boundsHeight);
				// isOffScreen - https://github.com/destroytoday/DestroyFramework/blob/master/src/com/destroytoday/util/WindowUtil.as
				if (Screen.getScreensForRectangle(bounds).length == 0) return false;
				nativeWindow.bounds=bounds;
				return true;
			}
			return false;
		}
	}
}