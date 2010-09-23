package {
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import net.tw.gml.player.GMLPlayer;
	
	[SWF(backgroundColor="#000000", frameRate="61", width="550", height="400")]
	public class PixelOkr extends Sprite {
		protected var _miniPlayer:GMLPlayer;
		protected var _player:GMLPlayer;
		protected var _loader:URLLoader;
		public function PixelOkr() {
			stage.quality=StageQuality.LOW;
			//
			_player=new GMLPlayer(new Point(stage.stageWidth, stage.stageHeight));
			addChild(_player);
			//
			var subdiv:uint=1;
			_miniPlayer=new GMLPlayer(new Point(11*subdiv, 8*subdiv));
			_miniPlayer.ignoreSettings=true;
			//_miniPlayer.x=(stage.stageWidth-_miniPlayer.width)/2;
			//_miniPlayer.y=(stage.stageHeight-_miniPlayer.height)/2;
			_miniPlayer.x=_miniPlayer.y=20;
			addChild(_miniPlayer);
			//
			_loader=new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onLoad);
			load();
		}
		protected function load():void {
			_loader.load(new URLRequest('http://000000book.com/data/18044.gml'));
		}
		protected function onLoad(e:Event):void {
			trace('load');
			var xml:XML=new XML(_loader.data);
			_miniPlayer.play(xml);
			_player.play(xml);
		}
	}
}