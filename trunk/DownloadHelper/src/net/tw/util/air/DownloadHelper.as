package net.tw.util.air {
	import flash.events.*;
	import flash.filesystem.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	/**
	 * @author Quentin T - http://toki-woki.net
	 * idea: http://elromdesign.com/blog/2009/01/14/adobe-air-15-downloadmanager-api-download-files-from-web-server-to-your-local-drive/
	 * more: http://www.flashrealtime.com/play-currently-downloading-video-in-air-filestream-and-bytearray/
	 */
	public class DownloadHelper {
		protected var _url:URLRequest;
		protected var _destination:File;
		protected var _fs:FileStream;
		protected var _stream:URLStream;
		protected var _ba:ByteArray;
		//
		public function DownloadHelper(url:URLRequest, destination:File) {
			_url=url;
			_destination=destination;
			_fs=new FileStream();
			_stream=new URLStream();
		}
		public function start():void {
			_stream.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_stream.addEventListener(Event.COMPLETE, onComplete);
			_fs.open(_destination, FileMode.WRITE);
			_stream.load(_url);
		}
		protected function stop() {
			_fs.close();
			_stream.close();
			_stream.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			_stream.removeEventListener(Event.COMPLETE, onComplete);
		}
		public function cancel():void {
			stop();
			_destination.deleteFileAsync();
		}
		protected function onProgress(e:ProgressEvent):void {
			_ba=new ByteArray();
			_stream.readBytes(_ba, 0, _stream.bytesAvailable);
			_fs.writeBytes(_ba, 0, _ba.length);
		}
		protected function onComplete(e:Event):void {
			stop();
		}
		public function get stream():URLStream {
			return _stream;
		}
		public function get destination():File {
			return _destination;
		}
		public function get url():URLRequest {
			return _url;
		}
	}
}