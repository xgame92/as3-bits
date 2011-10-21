package net.tw.mvcs.models.window.signals {
	import flash.display.NativeWindow;
	
	import org.osflash.signals.Signal;
	
	public class WindowStateRestoreRequested extends Signal {
		public function WindowStateRestoreRequested() {
			super(NativeWindow);
		}
	}
}