package net.tw.mx.controls {
	import mx.controls.Label;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import mx.graphics.ImageSnapshot;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import mx.events.FlexEvent;
	import flash.events.Event;
	//
	public class GradientLabel extends Label {
		protected var _shape:Shape;
		protected var _bitmap:Bitmap;
		protected var _colorFrom:uint=0xff0000;
		protected var _colorTo:uint=0x0000ff;
		protected var _angle:uint=90;
		//
		public function GradientLabel()	{
			super();
			addEventListener(FlexEvent.UPDATE_COMPLETE, drawGradient);
		}
		override protected function createChildren():void {
			super.createChildren();
			textField.visible=false;
		}
		public function set colorFrom(c:uint):void {
			_colorFrom=c;
			drawGradient();
		}
		public function get colorFrom():uint {
			return _colorFrom;
		}
		public function set colorTo(c:uint):void {
			_colorTo=c;
			drawGradient();
		}
		public function get colorTo():uint {
			return _colorTo;
		}
		public function get angle():uint {
			return _angle;
		}
		public function set angle(a:uint):void {
			_angle=a;
			drawGradient();
		}
		public function drawGradient(e:Event=null):void {
			if (!textField) return;
			//
			var bd:BitmapData=new BitmapData(textField.width, textField.height, true, 0);
			bd.draw(textField);
			//
			if (_bitmap) {
				_bitmap.bitmapData=bd;
			} else {
				_bitmap = new Bitmap(bd, "auto", true);
				_bitmap.cacheAsBitmap = true;
				addChild(_bitmap);
			}
			//
			var gm:Matrix = new Matrix();
			gm.createGradientBox(_bitmap.width, _bitmap.height, _angle * Math.PI / 180);
			//
			if (!_shape) {
				_shape = new Shape();
				_shape.cacheAsBitmap = true;
			}
			_shape.graphics.clear();
			_shape.graphics.beginGradientFill(GradientType.LINEAR, [_colorFrom, _colorTo], [1,1], [0, 255], gm);
			_shape.graphics.drawRect(0, 0, _bitmap.width, _bitmap.height);
			_shape.graphics.endFill();
			//
			if (!_shape.stage) {
				_shape.mask = _bitmap;
				addChild(_shape);
			}
			_bitmap.x=_shape.x=textField.x;
			_bitmap.y=_shape.y=textField.y;
		}		
	}
}