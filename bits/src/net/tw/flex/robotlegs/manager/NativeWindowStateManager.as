package net.tw.flex.robotlegs.manager {
	
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowDisplayState;
	import flash.display.Stage;
	import flash.events.NativeWindowDisplayStateEvent;
	
	import net.tw.flex.robotlegs.manager.signal.NativeWindowStateChangedSignal;
	
	import org.robotlegs.mvcs.Actor;
	
	public class NativeWindowStateManager extends Actor {
		protected var _stage:Stage;
		//
		[Inject]
		public var windowStateChanged:NativeWindowStateChangedSignal;
		//
		[PostConstruct]
		public function postConstruct():void {
			_stage=NativeApplication.nativeApplication.openedWindows[0].stage;
			nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, onStateChange);
		}
		protected function onStateChange(e:NativeWindowDisplayStateEvent):void {
			windowStateChanged.dispatch();
		}
		public function get nativeWindow():NativeWindow {
			return _stage.nativeWindow;
		}
		public function maximize():void {
			nativeWindow.maximize();
		}
		public function restore():void {
			nativeWindow.restore();
		}
		public function minimize():void {
			nativeWindow.minimize();
		}
		public function get maximized():Boolean {
			return nativeWindow.displayState==NativeWindowDisplayState.MAXIMIZED;
		}
		public function toggleMax():void {
			maximized ? restore() : maximize();
		}
	}
}