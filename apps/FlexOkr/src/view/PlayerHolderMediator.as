package view {
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import net.tw.gml.GMLCreator;
	import net.tw.gml.player.GMLPlayer;
	
	import org.robotlegs.mvcs.Mediator;
	
	import view.event.DrawActionEvent;
	import view.event.InkSettingEvent;
	import view.event.ModeChangeEvent;
	import view.event.TagSelectionEvent;
	
	public class PlayerHolderMediator extends Mediator {
		[Inject]
		public var playerHolder:PlayerHolder;
		//
		protected var _loadedGML:XML;
		protected var _player:GMLPlayer;
		protected var _gmlLoader:URLLoader;
		protected var _gmlID:String;
		protected var _creator:GMLCreator;
		//
		override public function onRegister():void {
			addContextListener(InkSettingEvent.CHANGE, onInkSettingChange);
			_player=new GMLPlayer(new Point(playerHolder.width, playerHolder.height));
			playerHolder.addChild(_player);
			goLoad('latest');
			//SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, onAddressChange);
			//SWFAddress.addEventListener(SWFAddressEvent.INTERNAL_CHANGE, onAddressChange);
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onAddressChange);
			/*addContextListener(TagSelectionEvent.SELECT, onTagSelection);
			addContextListener(ModeChangeEvent.MODE_CHANGE, onModeChange);
			//
			addContextListener(DrawActionEvent.DONE, onDrawDone);
			addContextListener(DrawActionEvent.CLEAR, onDrawClear);
			addContextListener(DrawActionEvent.SUBMIT, onSubmit);*/
		}
		protected function onInkSettingChange(e:InkSettingEvent):void {
			_player.minThickness=e.minSize;
			_player.maxThickness=e.maxSize;
			_player.dripProbability=e.drips;
			_player.replay();
		}
		protected function onAddressChange(e:SWFAddressEvent):void {
			trace(e);
			if (e.pathNames[0]=='play') goLoad(e.pathNames[1]);
		}
		/*protected function onTagSelection(e:TagSelectionEvent):void {
			goLoad(e.id);
		}*/
		protected function goLoad(gmlID:String):void {
			if (!_gmlLoader) {
				_gmlLoader=new URLLoader();
				_gmlLoader.addEventListener(Event.COMPLETE, onGMLLoaded);
			}
			_gmlID=gmlID;
			_gmlLoader.load(new URLRequest('http://000000book.com/data/'+_gmlID+'.gml'));
		}
		protected function onGMLLoaded(e:Event):void {
			_loadedGML=new XML(_gmlLoader.data);
			_player.play(_loadedGML);
		}
		protected function onModeChange(e:ModeChangeEvent):void {
			_player.stop();
			if (e.mode==ModeChangeEvent.PLAY_MODE) {
				if (_creator) _creator.deactivate();
				if (_loadedGML) _player.play(_loadedGML);
			} else {
				if (!_creator) _creator=new GMLCreator(_player);
				_creator.activate();
			}
		}
		/*protected function onDrawDone(e:DrawActionEvent):void {
			_creator.deactivate();
			_player.play(_creator.getGML());
		}
		protected function onDrawClear(e:DrawActionEvent):void {
			_creator.activate();
			_player.stop();
		}
		protected function onSubmit(e:DrawActionEvent):void {
			var appName:String='Okr';
			dispatch(new DrawActionEvent(DrawActionEvent.UPLOAD, e.keywords, _creator.getGML(appName, e.keywords), appName));
		}*/
	}
}