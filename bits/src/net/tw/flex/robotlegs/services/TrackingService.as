package net.tw.flex.robotlegs.services {
	import com.google.analytics.GATracker;
	
	import flash.display.DisplayObject;
	
	import org.robotlegs.mvcs.Actor;
	
	public class TrackingService extends Actor {
		protected var _tracker:GATracker;
		public function init(view:DisplayObject, account:String, doTrackLaunch:Boolean=true, version:String=null):void {
			_tracker=new GATracker(view, account/*, 'AS3', true*/);
			if (doTrackLaunch) trackLaunch(version);
		}
		public function trackLaunch(version:String=null):Boolean {
			return _tracker.trackEvent('App', 'Launch', version);
		}
		/*public function trackSearch(s:String):void {
			_tracker.trackEvent('App', 'Search', s);
		}*/
		public function trackEvent(category:String, action:String, label:String=null, value:Number=NaN):Boolean {
			return _tracker.trackEvent(category, action, label, value);
		}
	}
}