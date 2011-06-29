package service {
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import mx.controls.Alert;
	
	import org.robotlegs.mvcs.Actor;
	
	import service.event.GMLSearchResultEvent;
	
	public class GMLSearchService extends Actor {
		protected var _query:String;
		public static const BRIDGE_ENDPOINT:String='http://toki-woki.net/lib/bridge.php?url=';
		public static const SEARCH_ENDPOINT:String='http://www.tpolm.org/~ps/crawl/gmlrss.php?keywords=';
		protected var _loader:URLLoader;
		public function GMLSearchService() {
			super();
			//Security.loadPolicyFile('http://www.tpolm.org/~ps/crawl/crossdomain.xml');
		}
		public function search(q:String):void {
			_query=q;
			if (!_loader) {
				_loader=new URLLoader();
				_loader.addEventListener(Event.COMPLETE, onLoadComplete);
				//
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				//_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onError);
				//_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			}
			_loader.load(new URLRequest(BRIDGE_ENDPOINT+encodeURIComponent(SEARCH_ENDPOINT+q)));
		}
		protected function onLoadComplete(e:Event):void {
			var x:XML=new XML(_loader.data);
			var res:Array=[];
			if (String(uint(_query))==_query) res.push(_query);
			var guid:XML;
			for each(guid in x..guid) {
				res.push(String(guid));
			}
			res.push('random');
			res.push('latest');
			dispatch(new GMLSearchResultEvent(GMLSearchResultEvent.RESULTS_READY, res));
		}
		protected function onError(e:Event):void {
			Alert.show(e.toString(), "Error!");
		}
	}
}