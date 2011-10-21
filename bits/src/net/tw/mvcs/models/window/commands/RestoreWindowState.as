package net.tw.mvcs.models.window.commands {
	import flash.display.NativeWindow;
	
	import net.tw.mvcs.models.window.WindowStateModel;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class RestoreWindowState extends SignalCommand {
		[Inject]
		public var nativeWindow:NativeWindow;
		
		override public function execute():void {
			WindowStateModel.restoreWindowState(nativeWindow);
		}
	}
}