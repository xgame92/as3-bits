package net.tw.gml.player  {
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.*;
	
	import hype.framework.display.BitmapCanvas;

	public class GMLPlayer extends Sprite {
		protected var _gmlXML:XML;
		protected var _nbPTs:uint;
		protected var _prevPoint:Point;
		protected var _currentPT:uint;
		protected var _currentStroke:XML;
		protected var _redrawInterval:uint;
		//
		public var lineColor:uint=0xffffff;
		//
		protected var _minLineSize:Number=.5;
		protected var _maxLineSize:Number=50;
		//
		public var minThickness:Number=1;
		public var maxThickness:Number=16;
		//
		public var drip:Boolean=true;
		public var dripProbability:Number=.25;
		protected var _maxDripHeight:Number=60;
		//
		protected var _padding:uint=_maxDripHeight;
		protected var _canvas:Sprite;
		protected var _bc:BitmapCanvas;
		//
		public var ignoreSettings:Boolean=false;
		//
		protected var _drips:Vector.<Drip>=new Vector.<Drip>();
		//
		protected var _wSize:Point;
		//
		public function GMLPlayer(size:Point) {
			_wSize=size;
			mouseChildren=false;
			_canvas=new Sprite();
			addChild(_canvas);
			_bc=new BitmapCanvas(size.x, size.y);
			_bc.startCapture(_canvas, true);
			_bc.addEventListener(Event.ENTER_FRAME, onFrame);
			addChild(_bc);
			/*
			menu=new WheelMenu(this, 7);
			menu.setItem(0, 'Random', 'random.gml');
			menu.setItem(1, 'Latest', 'latest.gml');
			menu.setItem(2, 'Boner', '18136.gml');
			menu.setItem(3, 'DASP', '932.gml');
			menu.setItem(4, 'KATSU', '161.gml');
			menu.setItem(5, 'SEEN', '1399.gml');
			menu.setItem(6, 'Hello', '148.gml');
			*/
		}
		public function get size():Point {
			return _wSize;
		}
		public function get g():Graphics {
			return _canvas.graphics;
		}
		public function get prevPoint():Point {
			return _prevPoint;
		}
		public function stop():void {
			removeEventListener(Event.ENTER_FRAME, handleNextStep);
			if (_redrawInterval) clearInterval(_redrawInterval);
			clear();
		}
		public function play(gml:XML):void {
			_gmlXML=new XML(gml);
			_nbPTs=_gmlXML..pt.length();
			if (_nbPTs==0) {
				trace('empty tag');
				return;
			}
			fixPTs();
			replay();
		}
		protected function fixPTs():void {
			var clientName:String=_gmlXML..client.name;
			//trace(_gmlXML..screenBounds.toXMLString());
			var rotate:Boolean=(clientName && (clientName=='Graffiti Analysis 2.0: DustTag' || clientName=='DustTag: Graffiti Analysis 2.0' || clientName=='Fat Tag - Katsu Edition'));
			var pt:XML;
			var minPoint:Point=new Point(Number.MAX_VALUE, Number.MAX_VALUE);
			var maxPoint:Point=new Point(0, 0);
			for each(pt in _gmlXML..pt) {
				minPoint.x=Math.min(minPoint.x, pt.x);
				minPoint.y=Math.min(minPoint.y, pt.y);
				maxPoint.x=Math.max(maxPoint.x, pt.x);
				maxPoint.y=Math.max(maxPoint.y, pt.y);
			}
			var point:Point=new Point();
			var prevPoint:Point;
			var distance:Number;
			var prevStroke:XML;
			var minLength:Number=Number.MAX_VALUE;
			var maxLength:Number=0;
			for each(pt in _gmlXML..pt) {
				point=new Point((pt.x-minPoint.x)/(maxPoint.x-minPoint.x), (pt.y-minPoint.y)/(maxPoint.y-minPoint.y));
				if (rotate) point=new Point(point.y, 1-point.x);
				pt.x=point.x;
				pt.y=point.y;
				//
				if (prevPoint && prevStroke==pt.parent()) {
					distance=Point.distance(getPointCoords(prevPoint), getPointCoords(point));
					if (distance>maxLength) maxLength=distance;
					if (distance<minLength) minLength=distance;
				}
				prevPoint=point;
				prevStroke=pt.parent();
			}
			_minLineSize=minLength;
			_maxLineSize=maxLength;
		}
		protected function handlePoint():void {
			var p:XML=_gmlXML..pt[_currentPT];
			var pt:Point=getCoords(p);
			if (p.parent()!=_currentStroke) {
				_currentStroke=p.parent();
				moveTo(pt);
			} else {
				lineTo(pt);
			}
			_currentPT++;
		}
		protected function handleNextStep(e:Event=null):void {
			if (_currentPT>=_nbPTs) {
				//trace('out');
				removeEventListener(Event.ENTER_FRAME, handleNextStep);
				clearTimeout(_redrawInterval);
				_redrawInterval=setTimeout(replay, 2000);
				return;
			}
			handlePoint();
		}
		public function replay():void {
			clear();
			_currentStroke=null;
			_currentPT=0;
			addEventListener(Event.ENTER_FRAME, handleNextStep);
			handleNextStep();
		}
		public function get padding():Number {
			return ignoreSettings ? 1 : _padding;
		}
		protected function getPointCoords(pt:Point):Point {
			return new Point(padding+(size.x-2*padding)*pt.x, padding+(size.y-2*padding)*pt.y);
		}
		protected function getCoords(pt:XML):Point {
			return getPointCoords(new Point(pt.x, pt.y));
		}
		protected function onFrame(e:Event):void {
			g.clear();
			//
			var dr:Drip;
			for each (dr in _drips) {
				g.moveTo(dr.p.x, dr.p.y);
				dr.drop();
				g.lineStyle(dr.thickness, lineColor);
				g.lineTo(dr.p.x, dr.p.y);
				if (dr.h>=dr.maxHeight) _drips.splice(_drips.indexOf(dr), 1);
			}
		}
		public function moveTo(pt:Point, storePos:Boolean=true):Point {
			g.moveTo(pt.x, pt.y);
			if (storePos) _prevPoint=pt;
			return pt;
		}
		public function moveToMouse():Point {
			return moveTo(mousePoint);
		}
		public function lineTo(pt:Point, storePos:Boolean=true):Point {
			var thickness:Number;
			if (ignoreSettings) {
				thickness=1;
			} else {
				var length:Number=Point.distance(prevPoint, pt);
				var lengthRatio:Number=1-((length-_minLineSize)/(_maxLineSize-_minLineSize));
				thickness=minThickness+lengthRatio*(maxThickness-minThickness);
			}
			if (prevPoint) moveTo(prevPoint);
			g.lineStyle(thickness, lineColor);
			g.lineTo(pt.x, pt.y);
			if (storePos) _prevPoint=pt;
			//
			if (!ignoreSettings && drip && Math.random()<=dripProbability) {
				_drips.push(new Drip(pt, _maxDripHeight));
			}
			return pt;
		}
		public function lineToMouse():Point {
			return lineTo(mousePoint);
		}
		public function get mousePoint():Point {
			return new Point(mouseX, mouseY);
		}
		protected function clear():void {
			clearTimeout(_redrawInterval);
			g.clear();
			_bc.clear();
			var d:Drip;
			while(_drips.length) d=_drips.pop();
			_prevPoint=new Point();
		}
	}
}