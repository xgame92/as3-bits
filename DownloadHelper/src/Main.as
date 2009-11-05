package {
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import net.tw.util.air.DownloadHelper;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class Main extends Sprite {
		public function Main():void {
			var dh:DownloadHelper=new DownloadHelper(new URLRequest('http://toki-woki.net/stock/Buck65-B.Sc.mp3'), File.desktopDirectory.resolvePath('track.mp3'));
			dh.start();
		}
	}
}