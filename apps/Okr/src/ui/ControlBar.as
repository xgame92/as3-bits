package ui {
	import com.bit101.components.*;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ControlBar extends Sprite {
		public var slMinSize:HUISlider;
		public var slMaxSize:HUISlider;
		public var slDrip:HUISlider;
		//
		public var btnPlay:PushButton;
		public var btnDraw:PushButton;
		//
		protected var _boxPlay:HBox;
		public var tiSearch:InputText;
		public var btnSearch:PushButton;
		public var cbResults:ComboBox;
		//
		public static const MODE_PLAY:String='MODE_PLAY';
		public static const MODE_DRAW:String='MODE_DRAW';
		//
		public function ControlBar() {
			new Label(this, 0, 0, 'Ink Settings:');
			slMinSize=new HUISlider(this, 100, 0, 'Min Size', onSettingChange);
			slMinSize.minimum=1;
			slMinSize.maximum=30;
			slMinSize.value=1;
			slMaxSize=new HUISlider(this, 300, 0, 'Max Size', onSettingChange);
			slMaxSize.minimum=1;
			slMaxSize.maximum=30;
			slMaxSize.value=16;
			slDrip=new HUISlider(this, 500, 0, 'Drips', onSettingChange);
			slDrip.minimum=0;
			slDrip.maximum=100;
			slDrip.value=25;
			//
			new Label(this, 0, 20, 'Mode:');
			btnPlay=new PushButton(this, 100, 20, 'Play', onMode);
			btnDraw=new PushButton(this, 149, 20, 'Draw', onMode);
			btnPlay.width=btnDraw.width=50;
			btnPlay.toggle=btnDraw.toggle=true;
			btnPlay.selected=true;
			//
			_boxPlay=new HBox(this, 220, 20);
			new Label(_boxPlay, 0, 0, "Search");
			tiSearch=new InputText(_boxPlay);
			btnSearch=new PushButton(_boxPlay, 0, 0, "Go", onSearch);
			tiSearch.height=btnSearch.height;
			btnSearch.width=40;
			cbResults=new ComboBox(_boxPlay);
			cbResults.visible=false;
			//cbResults.items=defaultResItems;
			//cbResults.selectedIndex=cbResults.items.length-1;
			//
			updateUI();
		}
		protected function get defaultResItems():Array {
			return [{label:'---'}, {label:'random'}, {label:'latest'}];
		}
		protected function onSearch(e:MouseEvent=null):void {
			if (String(uint(tiSearch.text))==tiSearch.text) {
				onSearchRes([{label:tiSearch.text}]);
			}
		}
		protected function onSearchRes(res:Array):void {
			var def:Array=defaultResItems;
			for (var i:int=0; i<def.length; i++) {
				res.push(def[i]);
			}
			cbResults.addEventListener(Component.DRAW, selectFirstComboItem);
			cbResults.items=res;
			cbResults.draw();
			cbResults.visible=true;
		}
		protected function selectFirstComboItem(e:Event):void {
			trace('!!');
			cbResults.removeEventListener(Component.DRAW, selectFirstComboItem);
			cbResults.selectedIndex=0;
		}
		protected function onSettingChange(e:Event):void {
			trace('setting');
		}
		public function get mode():String {
			return btnPlay.selected ? MODE_PLAY : MODE_DRAW;
		}
		protected function onMode(e:Event):void {
			var pb:PushButton=PushButton(e.target);
			pb.selected=true;
			PushButton(pb==btnPlay ? btnDraw : btnPlay).selected=false;
			updateUI();
		}
		protected function updateUI():void {
			if (mode==MODE_PLAY) {
				
			} else {
				
			}
		}
	}
}