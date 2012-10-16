package net.tw.mvcs.services.track {
	import com.google.analytics.GATracker;
	
	import flash.display.DisplayObject;
	
	public class TrackingService {
		
		[Inject]
		public var settings:ITrackingServiceSettings;
		
		protected var _tracker:GATracker;
		
		[PostConstruct]
		public function init():void {
			_tracker=new GATracker(settings.view, settings.account, settings.mode, settings.visualDebug);
			if (settings.trackLaunch) trackLaunch(settings.appVersion);
		}
		public function trackLaunch(version:String=null):Boolean {
			return trackEvent('App', 'Launch', version);
		}
		public function trackEvent(category:String, action:String, label:String=null, value:Number=NaN):Boolean {
			return _tracker.trackEvent(category, action, label, value);
		}
	}
}