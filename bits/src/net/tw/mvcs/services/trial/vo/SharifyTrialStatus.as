package net.tw.mvcs.services.trial.vo {
	import it.sharify.SharifyStatus;

	public class SharifyTrialStatus {
		public function SharifyTrialStatus($status:int=0):void {
			statusID=$status;
		}
		
		protected var _statusID:int;
		public function get statusID():int {
			return _statusID;
		}
		public function set statusID(value:int):void {
			if (_statusID == value) return;
			_statusID = value;
			
			if (isTrial) {
				_state=SharifyTrialState.TRIAL;
			} else if (isTrialTimedOut) {
				_state=SharifyTrialState.TRIAL_TIMED_OUT;
			} else if (isRegistered || isRegistrationSuccess || isErrorAlreadyRegistered) {
				_state=SharifyTrialState.REGISTERED;
			} else if (isErrorRegistrationRevoked) {
				_state=SharifyTrialState.REVOKED;
			}
		}
		protected var _daysRemaing:int;
		public function get daysRemaing():int {
			return _daysRemaing;
		}
		public function set daysRemaing(value:int):void {
			if (_daysRemaing == value) return;
			_daysRemaing = value;
		}
		
		protected var _userName:String;
		public function get userName():String {
			return _userName;
		}
		public function set userName(value:String):void {
			if (_userName == value) return;
			_userName = value;
		}
		
		public function get pending():Boolean {
			return statusID==0;
		}
		
		public function get isTrial():Boolean {
			return statusID==SharifyStatus.STATUS_TRIAL;
		}
		public function get isRegistered():Boolean {
			return statusID==SharifyStatus.STATUS_REGISTERED;
		}
		public function get isTrialTimedOut():Boolean {
			return statusID==SharifyStatus.STATUS_TRIAL_TIMED_OUT;
		}
		public function get isServerUnavailable():Boolean {
			return statusID==SharifyStatus.STATUS_SERVER_UNAVAILABLE;
		}
		public function get isErrorKeyNotFound():Boolean {
			return statusID==SharifyStatus.STATUS_ERROR_KEY_NOT_FOUND;
		}
		public function get isErrorAlreadyRegistered():Boolean {
			return statusID==SharifyStatus.STATUS_ERROR_ALREADY_REGISTERED;
		}
		public function get isErrorRegistrationRevoked():Boolean {
			return statusID==SharifyStatus.STATUS_ERROR_REGISTRATION_REVOKED;
		}
		public function get isRegistrationSuccess():Boolean {
			return statusID==SharifyStatus.STATUS_REGISTRATION_SUCCESS;
		}
		
		public function get isError():Boolean {
			return isErrorKeyNotFound || isErrorAlreadyRegistered || isErrorRegistrationRevoked;
		}
		public function get canAccessAllFeatures():Boolean {
			return isRegistered || isRegistrationSuccess;
		}
		public function get canAccessFeatures():Boolean {
			return isTrial || canAccessAllFeatures;
		}
		public function get cannotAccessFeatures():Boolean {
			return isErrorRegistrationRevoked || isTrialTimedOut;
		}
		
		protected var _state:String;
		public function get state():String {
			return _state;
		}
		public function get stateIsTrial():Boolean {
			return _state==SharifyTrialState.TRIAL;
		}
		public function get stateIsTrialTimedOut():Boolean {
			return _state==SharifyTrialState.TRIAL_TIMED_OUT;
		}
		public function get stateIsRegistered():Boolean {
			return _state==SharifyTrialState.REGISTERED;
		}
		public function get stateIsRevoked():Boolean {
			return _state==SharifyTrialState.REVOKED;
		}
		
		public function toString():String {
			return '[SharifyTrialStatus statusID='+statusID+']';
		}
	}
}