package  {
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.text.*;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class GradientText extends Sprite {
		private var field:TextField;
		private var shape:Shape;
		private var bitmap:Bitmap;
		//
		protected var _colorFrom:uint;
		protected var _colorTo:uint;
		//
		public function GradientText(defFormat:TextFormat, colorFrom:uint=0xff0000, colorTo:uint=0x00ff00, defText:String=null) {
			super();
			//
			_colorFrom=colorFrom;
			_colorTo=colorTo;
			//
			field = new TextField();
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.embedFonts = true;
			field.defaultTextFormat = defFormat;
			//
			if (defText) setText(defText);
		}
		public function set text(s:String):void {
			field.text = s;
		}
		public function get text():String {
			return field.text;
		}
		//
		public function setText(s:String, doRefresh:Boolean=true):void {
			text=s;
			if (doRefresh) refresh();
		}
		//
		public function refresh():void {
			var bitmapdata:BitmapData = new BitmapData(field.width, field.height, true, 0);
			bitmapdata.draw(field);
			//
			if (bitmap) bitmap.bitmapData=bitmapdata;
			else {
				bitmap = new Bitmap(bitmapdata, "auto", true);
				bitmap.cacheAsBitmap = true;
				addChild(bitmap);
			}
			//
			var gradientmatrix:Matrix = new Matrix();
			gradientmatrix.createGradientBox(bitmap.width, bitmap.height, Math.PI/2);
			//
			if (!shape) {
				shape = new Shape();
				shape.cacheAsBitmap = true;
			}
			shape.graphics.clear();
			shape.graphics.beginGradientFill(GradientType.LINEAR, [_colorFrom, _colorTo], [1,1], [0, 255], gradientmatrix);
			shape.graphics.drawRect(0, 0, bitmap.width, bitmap.height);
			shape.graphics.endFill();
			//
			if (!shape.stage) {
				shape.mask = bitmap;
				addChild(shape);
			}
		}
		public function setFormat(f:TextFormat, doRefresh:Boolean=true):void {
			field.setTextFormat(field.defaultTextFormat=f);
			if (doRefresh) refresh();
		}
		public function getFormat():TextFormat {
			return field.defaultTextFormat;
		}
	}
}