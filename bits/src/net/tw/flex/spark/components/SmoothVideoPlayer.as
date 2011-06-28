package net.tw.flex.spark.components {
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import spark.components.VideoPlayer;
	
	public class SmoothVideoPlayer extends VideoPlayer {
		public function SmoothVideoPlayer() {
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCC);
		}
		protected function onCC(e:Event):void {
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCC);
			videoDisplay.videoObject.smoothing=true;
		}
	}
}