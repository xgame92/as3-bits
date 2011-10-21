package net.tw.mvcs.models.window.signals {
	import flash.display.NativeWindow;
	
	import org.osflash.signals.Signal;
	
	public class WindowStateStoreRequested extends Signal {
		public function WindowStateStoreRequested() {
			super(NativeWindow);
		}
	}
}