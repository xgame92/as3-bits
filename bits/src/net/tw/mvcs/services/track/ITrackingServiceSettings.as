package net.tw.mvcs.services.track {
	import flash.display.DisplayObject;

	public interface ITrackingServiceSettings {
		function get view():DisplayObject;
		function get account():String;
		function get trackLaunch():Boolean;
		function get appVersion():String;
		function get mode():String;
		function get visualDebug():Boolean;
	}
}