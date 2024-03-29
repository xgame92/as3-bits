﻿package net.tw.text {
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
		public function GradientText(defFormat:TextFormat=null, colorFrom:uint=0xffffff, colorTo:uint=0x444444, defText:String=null) {
			super();
			//
			_colorFrom=colorFrom;
			_colorTo=colorTo;
			//
			if (!defFormat) defFormat=new TextFormat();
			//
			field = new TextField();
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.embedFonts = true;
			field.defaultTextFormat = defFormat;
			//
			if (defText) text=defText;
		}
		public function set text(s:String):void {
			setText(s, true);
		}
		public function get text():String {
			return field.text;
		}
		//
		public function setText(s:String, doRefresh:Boolean=false):void {
			field.text = s;
			if (doRefresh) refresh();
		}
		//
		public function refresh():void {
			var bitmapdata:BitmapData = new BitmapData(field.width, field.height, true, 0);
			bitmapdata.draw(field);
			//
			if (bitmap) {
				bitmap.bitmapData=bitmapdata;
			} else {
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
		public function get format():TextFormat {
			return field.defaultTextFormat;
		}
		public function set format(f:TextFormat):void {
			setFormat(f, true);
		}
		public function setFormat(f:TextFormat, doRefresh:Boolean=false):void {
			field.setTextFormat(field.defaultTextFormat=f);
			if (doRefresh) refresh();
		}
	}
}