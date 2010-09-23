package service {
	import flash.events.*;
	import flash.net.*;
	
	import org.robotlegs.mvcs.Actor;
	
	import service.event.UploadEvent;
	
	public class GMLUploadService extends Actor {
		public static const UPLOAD_ENDPOINT:String='http://000000book.com/data';
		//
		protected var _loader:URLLoader;
		//
		public function GMLUploadService() {
			super();
		}
		public function upload(x:XML, appName:String):void {
			var r:URLRequest=new URLRequest(UPLOAD_ENDPOINT);
			var vars:URLVariables=new URLVariables();
			vars['tag[gml]']=x.toXMLString();
			vars['tag[application]']=appName;
			r.method=URLRequestMethod.POST;
			r.data=vars;
			if (!_loader) {
				_loader=new URLLoader();
				_loader.addEventListener(Event.COMPLETE, onUploadComplete);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				//_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			}
			_loader.load(r);
		}
		protected function onUploadComplete(e:Event):void {
			dispatch(new UploadEvent(UploadEvent.UPLOAD_SUCCESS, e.target.data));
		}
		protected function onError(e:IOErrorEvent):void {
			dispatch(new UploadEvent(UploadEvent.UPLOAD_ERROR));
		}
		/*protected function onStatus(e:HTTPStatusEvent):void {
			dispatch(new UploadEvent(UploadEvent.UPLOAD_ERROR));
		}*/
	}
}