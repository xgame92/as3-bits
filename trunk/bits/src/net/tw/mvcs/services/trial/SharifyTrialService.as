package net.tw.mvcs.services.trial {
	import flash.events.Event;
	
	import it.sharify.ISharify;
	import it.sharify.SharifyFactory;
	import it.sharify.SharifyStatus;
	import it.sharify.event.SharifyResponseEvent;
	
	import net.tw.mvcs.services.trial.signals.TrialStatusReceived;
	import net.tw.mvcs.services.trial.vo.SharifyTrialStatus;
	
	import org.robotlegs.mvcs.Actor;
	import net.tw.mvcs.services.trial.vo.TrialRegisterCredentials;
	
	public class SharifyTrialService extends Actor {
		
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
			_sa = (e.target as SharifyFactory).getInstance();
			
			_sa.init(settings.appID);
			_sa.addEventListener(SharifyResponseEvent.SHARIFY_RESPONSE, onSharifyResponse);
			_sa.checkLicenseStatus();
		}
		protected function onSharifyResponse(e:SharifyResponseEvent):void {
			_status=new SharifyTrialStatus(e.status);
			
			// !!! DEBUG
			//_status=new SharifyTrialStatus(e.status==101 ? 103 : e.status);
			
			if (status.isTrial) status.daysRemaing=uint(e.data);
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