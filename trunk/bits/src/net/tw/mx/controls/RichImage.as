package net.tw.mx.controls {
	import mx.controls.Image;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;

	/**
	 * @see http://www.flexer.info/2008/06/12/continuing-image-with-border/
	 */
	[Style(name="borderColor", type="uint", format="Color", inherit="no")]
	[Style(name="borderThickness", type="Number", format="Length", inherit="no")]
	[Style(name="borderAlpha", type="Number", format="Length", inherit="no")]
	//
	public class RichImage extends Image {
		public function RichImage() {
			super();
			smoothBitmapContent=true;
		}
		//
		// http://livedocs.adobe.com/flex/3/html/skinstyle_3.html#184113
		private static var classConstructed:Boolean = classConstruct();
		private static function classConstruct():Boolean {
			if (!StyleManager.getStyleDeclaration("RichImage")) {
				var defStyles:CSSStyleDeclaration = new CSSStyleDeclaration();
				defStyles.defaultFactory = function():void {
					this.borderThickness = 0;
					this.borderColor = '#ff0000';
					this.borderAlpha = 1;
				}
				StyleManager.setStyleDeclaration("RichImage", defStyles, true);
			}
			return true;
		}
		//
		override protected function updateDisplayList(w:Number, h:Number):void {
			try {super.updateDisplayList(w,h);} catch (e:Error) {}
			//
			graphics.clear();
			if (getStyle('borderThickness')==0 || !contentWidth || !contentHeight) return;
			var thickness:Number = getStyle('borderThickness');
			graphics.lineStyle(thickness, getStyle('borderColor'), getStyle('borderAlpha'), false, "normal", null, JointStyle.MITER);
			var startX:Number;
			var startY:Number;
			var endX:Number;
			var endY:Number;
			startX = -thickness/2;
			endX = contentWidth+thickness;
			startY = -thickness/2;
			endY = contentHeight+thickness;
			//
			graphics.drawRect(startX,startY,endX,endY);
			graphics.endFill();
		}
	}
}