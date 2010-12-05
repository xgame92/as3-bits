package net.tw.qnx.ui {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.bytearray.gif.events.FrameEvent;
	import org.bytearray.gif.events.GIFPlayerEvent;
	import org.bytearray.gif.player.GIFPlayer;
	
	import qnx.ui.display.Image;
	
	public class HybridImage extends Image {
		protected var _bmp:Bitmap;
		protected var _urlLoader:URLLoader;
		protected var _handleGIF:Boolean=true;
		protected var _gifPlayer:GIFPlayer;
		protected var _gifSize:Rectangle;
		public function HybridImage() {
			super();
			_urlLoader=new URLLoader();
			_urlLoader.dataFormat=URLLoaderDataFormat.BINARY;
			_gifPlayer=new GIFPlayer();
			_gifPlayer.addEventListener(Event.COMPLETE, onGIFComplete);
		}
		public function get handleGIF():Boolean {
			return _handleGIF;
		}
		public function set handleGIF(b:Boolean):void {
			_handleGIF=b;
		}
		override public function setImage(image:Object):void {
			_gifPlayer.removeEventListener(FrameEvent.FRAME_RENDERED, onFrame);
			if ((image is String) && handleGIF) {
				_urlLoader.addEventListener(Event.COMPLETE, onLoad);
				_urlLoader.load(new URLRequest(image as String));
			} else {
				super.setImage(image);
			}
		}
		protected function onLoad(e:Event):void {
			_urlLoader.removeEventListener(Event.COMPLETE, onLoad);
			var ba:ByteArray=_urlLoader.data as ByteArray;
			if (ba.readUTFBytes(3)=='GIF') {
				_gifPlayer.addEventListener(FrameEvent.FRAME_RENDERED, onFrame);
				ba.position=0;
				_gifPlayer.loadBytes(ba);
			} else {
				ba.position=0;
				var l:Loader=new Loader();
				l.loadBytes(ba);
				l.contentLoaderInfo.addEventListener(Event.COMPLETE, onBytes);
			}
		}
		protected function onFrame(e:FrameEvent):void {
			setImage(_gifPlayer);
		}
		protected function onGIFComplete(e:GIFPlayerEvent):void {
			setSize(e.rect.width, e.rect.height);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		protected function onBytes(e:Event):void {
			var li:LoaderInfo=e.target as LoaderInfo;
			li.removeEventListener(Event.COMPLETE, onBytes);
			setImage(Bitmap(li.content).bitmapData);
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}