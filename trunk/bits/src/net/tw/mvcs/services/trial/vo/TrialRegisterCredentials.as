package net.tw.mvcs.services.trial.vo {
	public class TrialRegisterCredentials {
		public var email:String;
		public var key:String;
		public function TrialRegisterCredentials($email:String, $key:String):void {
			email=$email;
			key=$key;
		}
	}
}