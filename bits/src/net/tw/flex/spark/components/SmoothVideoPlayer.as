package net.tw.flex.spark.components {
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.VideoPlayer;
	
	public class SmoothVideoPlayer extends VideoPlayer {
		public function SmoothVideoPlayer() {
			super();
			
			addEventListener(FlexEvent.CREATION_COMPLETE, goSmooth);
			if (stage) goSmooth();
			else addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		protected function onStage(e:Event):void {
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, goSmooth);
		}
		protected function goSmooth(e:Event=null):void {
			try {
				videoDisplay.videoObject.smoothing=true;
			} catch (er:Error) {}
		}
	}
}