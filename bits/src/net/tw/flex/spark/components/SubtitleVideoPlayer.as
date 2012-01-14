package net.tw.flex.spark.components {
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.events.FlexEvent;
	
	import net.tw.flex.spark.components.skin.SubtitleVideoPlayerSkin;
	
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.media.MediaPlayerState;
	
	import spark.components.Label;
	import spark.components.ToggleButton;
	
	public class SubtitleVideoPlayer extends SmoothVideoPlayer {
		protected var _ns:NetStream;
		public function SubtitleVideoPlayer():void {
			super();
			var nc:NetConnection = new NetConnection();
			nc.connect(null);
			_ns=new NetStream(nc);
			_ns.client={onCaption:onStreamCaption};
			_ns.soundTransform=new SoundTransform(0);
			addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
			setStyle('skinClass', SubtitleVideoPlayerSkin);
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			subtitleLabel.visible=false;
			subtitleToggleButton.addEventListener(Event.CHANGE, onSubtitleVisibleChange);
		}
		
		[SkinPart(required="true", type="spark.components.Label")]
		public var subtitleLabel:Label;
		
		[SkinPart(required="true", type="spark.components.ToggleButton")]
		public var subtitleToggleButton:ToggleButton;
		
		override public function set source(value:Object):void {
			super.source=value;
			_ns.play(value);
			_ns.pause();
		}
		protected function onStreamCaption(captions:Array, speaker:Number):void {
			var s:String=captions.join(" ").replace("<br>", " ");
			subtitle=s;
		}
		public function get subtitle():String {
			return subtitleLabel.text;
		}
		public function set subtitle(s:String):void {
			subtitleLabel.text=s;
		}
		protected function onStateChange(e:MediaPlayerStateChangeEvent):void {
			switch (e.state) {
				case MediaPlayerState.PLAYING:
					subtitle='';
					_ns.seek(currentTime);
					_ns.resume();
					break;
				case MediaPlayerState.PAUSED:
					_ns.pause();
					break;
			}
		}
		
		private var _subtitleVisible:Boolean;
		[Bindable]
		public function get subtitleVisible():Boolean {
			return _subtitleVisible;
		}
		public function set subtitleVisible(value:Boolean):void {
			if (_subtitleVisible == value) return;
			_subtitleVisible = value;
			
			subtitleLabel.visible=value;
			subtitleToggleButton.selected=value;
		}
		
		protected function onSubtitleVisibleChange(e:Event):void {
			subtitleVisible=subtitleToggleButton.selected;
		}
	}
}