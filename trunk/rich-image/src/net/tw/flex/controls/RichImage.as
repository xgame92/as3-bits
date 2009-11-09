package net.tw.flex.controls {
	import mx.controls.Image;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;

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
		override protected function updateDisplayList(w:Number, h:Number):void {
			try {super.updateDisplayList(w,h);} catch (e:Error) {}
			//
			graphics.clear();
			if (getStyle('borderThickness')==0) return;
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