package net.tw.mvcs.services.trial {
	public class SharifyTrialServiceSettings implements ISharifyTrialServiceSettings {
		protected var _appID:String;
		public function SharifyTrialServiceSettings($appID:String):void {
			_appID=$appID;
		}
		public function get appID():String {
			return _appID;
		}
	}
}