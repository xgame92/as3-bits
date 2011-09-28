package net.tw.mvcs.services.trial {
	import flash.events.Event;
	
	import it.sharify.ISharify;
	import it.sharify.SharifyFactory;
	import it.sharify.SharifyStatus;
	import it.sharify.event.SharifyResponseEvent;
	
	import mx.utils.ObjectUtil;
	
	import net.tw.mvcs.services.trial.signals.TrialStatusReceived;
	import net.tw.mvcs.services.trial.vo.SharifyTrialStatus;
	import net.tw.mvcs.services.trial.vo.TrialRegisterCredentials;
	
	public class SharifyTrialService {
		
		protected var _sa:ISharify;
		protected var _status:SharifyTrialStatus;
		
		[Inject]
		public var settings:ISharifyTrialServiceSettings;
		
		[Inject]
		public var trialStatusReceived:TrialStatusReceived;
		
		[PostConstruct]
		public function init():void {
			_status=new SharifyTrialStatus();
			var sharifyFactory:SharifyFactory = new SharifyFactory();
			sharifyFactory.addEventListener(Event.COMPLETE, onSharifyFactoryReady);
		}
		protected function onSharifyFactoryReady(e:Event):void {
			var tg:SharifyFactory=e.target as SharifyFactory;
			tg.removeEventListener(Event.COMPLETE, onSharifyFactoryReady);
			_sa=tg.getInstance();
			
			_sa.init(settings.appID);
			_sa.addEventListener(SharifyResponseEvent.SHARIFY_RESPONSE, onSharifyResponse);
			_sa.checkLicenseStatus();
		}
		protected function onSharifyResponse(e:SharifyResponseEvent):void {
			
			// !!! DEBUG
			//e.status=103;
			//trace(e.status);
			//if (e.status==101) e.status=103;
			//if (e.status==102) e.status=101;
			//if (e.status==901) e.status=105;
			
			_status.statusID=e.status;
			
			if (status.isTrial) status.daysRemaing=uint(e.data);
			else if (status.isRegistered) _status.userName=e.data;
			dispatchStatus();
		}
		public function dispatchStatus():void {
			trialStatusReceived.dispatch(status);
		}
		
		public function register(credentials:TrialRegisterCredentials):void {
			_sa.register(credentials.email, credentials.key);
		}
		
		public function get status():SharifyTrialStatus {
			return _status;
		}
	}
}