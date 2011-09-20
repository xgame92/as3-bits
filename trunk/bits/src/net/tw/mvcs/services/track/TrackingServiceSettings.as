package net.tw.mvcs.services.track {
	import flash.display.DisplayObject;

	public class TrackingServiceSettings implements ITrackingServiceSettings {
		public function TrackingServiceSettings($view:DisplayObject, $account:String, $appVersion:String, $trackLaunch:Boolean=true, $mode:String='AS3', $visualDebug:Boolean=false) {
			_view=$view;
			_account=$account;
			_appVersion=$appVersion;
			_trackLaunch=$trackLaunch;
			_mode=$mode;
			_visualDebug=$visualDebug;
		}
		protected var _view:DisplayObject;
		public function get view():DisplayObject {
			return _view;
		}
		protected var _account:String;
		public function get account():String {
			return _account;
		}
		
		protected var _appVersion:String;
		public function get appVersion():String {
			return _appVersion;
		}
		
		protected var _trackLaunch:Boolean;
		public function get trackLaunch():Boolean {
			return _trackLaunch;
		}
		
		protected var _mode:String;
		public function get mode():String {
			return _mode;
		}
		
		protected var _visualDebug:Boolean;
		public function get visualDebug():Boolean {
			return _visualDebug;
		}
	}
}