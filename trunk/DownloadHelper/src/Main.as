package {
	import com.bit101.components.Label;
	import com.bit101.components.ProgressBar;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import net.hires.debug.Stats;
	import net.tw.util.air.DownloadHelper;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class Main extends Sprite {
		private var pb:ProgressBar;
		public function Main():void {
			var stats:Stats=new Stats();
			stats.x=stats.y=20;
			addChild(stats);
			pb=new ProgressBar(this, stats.x+stats.width+20, 20);
			var dh:DownloadHelper=new DownloadHelper(
				new URLRequest('http://toki-woki.net/stock/Buck65-B.Sc.mp3?'+getTimer()),
				File.desktopDirectory.resolvePath('file.mp3'));
			dh.stream.addEventListener(ProgressEvent.PROGRESS, onProgress);
			dh.stream.addEventListener(Event.COMPLETE, onComplete);
			dh.start();
		}
		private function onComplete(e:Event):void {
			trace('done!');
			new Label(this, pb.x, pb.y+pb.height+20, "Done!");
		}
		private function onProgress(e:ProgressEvent):void {
			pb.maximum=e.bytesTotal;
			pb.value=e.bytesLoaded;
		}
	}
}