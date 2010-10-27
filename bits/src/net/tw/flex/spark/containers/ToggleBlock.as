package net.tw.flex.spark.containers {
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexModuleFactory;
	import mx.styles.CSSStyleDeclaration;
	
	import net.tw.flex.spark.containers.skin.ToggleBlockDefaultSkin;
	
	import spark.components.SkinnableContainer;
	import spark.components.ToggleButton;
	
	[SkinState("opened")]
	public class ToggleBlock extends SkinnableContainer {
		protected var _title:String="ToggleBlock";
		protected var _opened:Boolean = true;
		//
		[SkinPart(required="false")]
		public var openButton:ToggleButton;
		//
		{
			(function ():void {
				var styles:CSSStyleDeclaration=FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("net.tw.flex.spark.containers.ToggleBlock");
				if (!styles) {
					var defStyles:CSSStyleDeclaration = new CSSStyleDeclaration();
					defStyles.defaultFactory = function():void {
						this.skinClass = Class(ToggleBlockDefaultSkin);
					}
					FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("net.tw.flex.spark.containers.ToggleBlock", defStyles, true);
				} else if (!styles.getStyle('skinClass')) {
					styles.setStyle('skinClass', Class(ToggleBlockDefaultSkin));
				}
			}());
		}
		//
		public function get opened():Boolean {
			return _opened;
		}
		public function set opened(value:Boolean):void {
			if (_opened != value) {
				_opened = value;
				invalidateProperties();
				invalidateSkinState();
			}
		}
		//
		public function get title():String {
			return _title;
		}
		public function set title(s:String):void {
			if (s==_title) return;
			_title=s;
			invalidateProperties();
		}
		//
		override protected function commitProperties():void {
			super.commitProperties();
			if (openButton) {
				openButton.label=_title;
				openButton.selected=opened;	
			}
		}
		//
		private function changeHandler(e:Event):void {
			opened = openButton.selected;
		}
		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			if (instance == openButton) {
				(instance as ToggleButton).addEventListener(Event.CHANGE, changeHandler);
			}
		}
		override protected function partRemoved(partName:String, instance:Object):void {
			if (instance == openButton) (instance as ToggleButton).removeEventListener(Event.CHANGE, changeHandler);
			super.partRemoved(partName, instance);
		}
		//
		override protected function getCurrentSkinState():String {
			return (opened ? 'opened' : super.getCurrentSkinState());
		}
	}
}