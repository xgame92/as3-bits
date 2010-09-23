package net.tw.gml.player {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Drip {
		//protected var _wall:Wall;
		protected var _thickness:Number;
		protected var _maxHeight:Number;
		public var h:Number=0;
		public var p:Point;
		public var y:Number;
		public function Drip($p:Point, $maxHeight:Number, $thickness:Number=2) {
			//_wall=$wall;
			_thickness=$thickness;
			_maxHeight=Math.random()*$maxHeight;
			p=$p;
			//wall.addChild(this);
			//wall.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		public function get maxHeight():Number {
			return _maxHeight;
		}
		public function get thickness():Number {
			return _thickness;
		}
		public function drop():void {
			p.y++;
			h++;
		}
		/*public function get wall():Wall {
			return _wall;
		}
		public function get g():Graphics {
			return wall.g;
		}
		protected function onFrame(e:Event):void {
			g.lineStyle(_thickness, wall.lineColor);
			g.moveTo(_x, _y+_h);
			_h++;
			g.lineTo(_x, _y+_h);
			if (_h>=_maxHeight)wall.removeEventListener(Event.ENTER_FRAME, onFrame);
		}
		public function release():void {
			wall.removeEventListener(Event.ENTER_FRAME, onFrame);
		}*/
	}
}