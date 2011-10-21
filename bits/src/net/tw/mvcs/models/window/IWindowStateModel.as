package net.tw.mvcs.models.window {
	import flash.display.NativeWindow;

	public interface IWindowStateModel {
		function get nativeWindow():NativeWindow;
		function store():Boolean;
		function restore():Boolean;
	}
}