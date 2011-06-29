package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.*;
	
	import net.tw.gml.GMLCreator;
	import net.tw.gml.player.GMLPlayer;
	
	import ui.ControlBar;

	[SWF(backgroundColor="#000000", frameRate="61", width="800", height="600")]
	public class Okr extends Sprite {
		protected var _control:ControlBar;
		protected var _player:GMLPlayer;
		protected var _gmlLoader:URLLoader;
		protected var _gmlID:String;
		protected var _creator:GMLCreator;
		
		public function Okr() {
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, layoutUI);
			//
			_player=new GMLPlayer(new Point(stage.stageWidth, stage.stageHeight));
			addChild(_player);
			_control=new ControlBar();
			addChild(_control);
			//
			//_creator=new GMLCreator(_player);
			//
			layoutUI();
			goLoad('latest');
		}
		protected function layoutUI(e:Event=null):void {
			//trace(_control.width);
			//_control.x=Math.round((stage.stageWidth-_control.width)/2);
			_player.x=(stage.stageWidth-_player.size.x)/2;
			_player.y=(stage.stageHeight-_player.size.y)/2;
		}
		protected function goLoad(gmlID:String):void {
			if (!_gmlLoader) {
				_gmlLoader=new URLLoader();
				_gmlLoader.addEventListener(Event.COMPLETE, onGMLLoaded);
			}
			_gmlID=gmlID;
			_gmlLoader.load(new URLRequest('http://000000book.com/data/'+_gmlID+'.gml'));
		}
		protected function onGMLLoaded(e:Event):void {
			_player.play(new XML(_gmlLoader.data));
		}
		protected function onThicknessSlider(e:Event):void {
			if (_control.slMinSize)	_player.minThickness=_control.slMinSize.value;
			if (_control.slMaxSize)	_player.maxThickness=_control.slMaxSize.value;
			if (_control.slDrip)	_player.dripProbability=_control.slDrip.value/_control.slDrip.maximum;
		}
	}
}