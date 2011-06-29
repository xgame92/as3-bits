package net.tw.gml.player  {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.*;
	
	import hype.framework.display.BitmapCanvas;
	
	
	//import net.tw.gml.player.Wall;

	public class GMLPlayer extends Sprite {
		//public var gmlURL:String='random.gml';
		//public var gmlURL:String='latest.gml';
		// KATSU
		//public var gmlURL:String='161.gml';
		// DASP
		//public var gmlURL:String='18046.gml';
		// JESUS SAVES
		//public var gmlURL:String='158.gml';
		// SEEN
		//public var gmlURL:String='1399.gml';
		// Hello world
		//public var gmlURL:String='148.gml';
		//public var gmlURL:String='18039.gml';
		// DASP
		//public var gmlURL:String='18046.gml';
		// DASP
		//public var gmlURL:String='18044.gml';
		// DASP bars
		//public var gmlURL:String='17608.gml';
		// DASP One-shot
		//public var gmlURL:String='932.gml';
		// DASP
		//public var gmlURL:String='18135.gml';
		// Boner
		//public var gmlURL:String='18136.gml';
		// yes
		//public var gmlURL:String='18152.gml';
		// Apology
		//public var gmlURL:String='18272.gml';
		//public var gmlURL:String='18325.gml';
		//
		//public var wall:Wall;
		//
		//protected var _padding:uint=40;
		//protected var _wallSize:Point;
		protected var _minPoint:Point;
		protected var _maxPoint:Point;
		protected var _gmlXML:XML;
		protected var _rotate:Boolean;
		protected var _nbPTs:uint;
		protected var _currentPT:uint;
		protected var _currentStroke:XML;
		protected var _redrawInterval:uint;
		//
		protected var _prevPoint:Point;
		public var lineColor:uint=0xffffff;
		//
		public var minLineSize:Number=.5;
		public var maxLineSize:Number=50;
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
		//protected var _size:Point;
		protected var _drips:Vector.<Drip>=new Vector.<Drip>();
		//
		protected var _wSize:Point;
		//
		public function GMLPlayer(size:Point) {
			_wSize=size;
			mouseEnabled=mouseChildren=false;
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
			clearInterval(_redrawInterval);
			clear();
		}
		public function play(gml:XML):void {
			_gmlXML=gml;
			var clientName:String=_gmlXML..client.name;
			_rotate=(clientName && (clientName=='Graffiti Analysis 2.0: DustTag' || clientName=='DustTag: Graffiti Analysis 2.0' || clientName=='Fat Tag - Katsu Edition'));
			_nbPTs=_gmlXML..pt.length();
			if (_nbPTs==0) {
				trace('empty tag');
				return;
			}
			var pt:XML;
			_minPoint=new Point(Number.MAX_VALUE, Number.MAX_VALUE);
			_maxPoint=new Point(0, 0);
			for each(pt in _gmlXML..pt) {
				_minPoint.x=Math.min(_minPoint.x, pt.x);
				_minPoint.y=Math.min(_minPoint.y, pt.y);
				_maxPoint.x=Math.max(_maxPoint.x, pt.x);
				_maxPoint.y=Math.max(_maxPoint.y, pt.y);
			}
			fixPTs();
			doDraw();
		}
		protected function fixPTs():void {
			var pt:XML;
			var point:Point=new Point();
			var prevPoint:Point;
			var distance:Number;
			var prevStroke:XML;
			var minLength:Number=Number.MAX_VALUE;
			var maxLength:Number=0;
			for each(pt in _gmlXML..pt) {
				point=fixPointCoords(new Point(pt.x, pt.y));
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
			minLineSize=minLength;
			maxLineSize=maxLength;
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
				trace('out');
				removeEventListener(Event.ENTER_FRAME, handleNextStep);
				_redrawInterval=setTimeout(doDraw, 2000);
				return;
			}
			handlePoint();
		}
		protected function doDraw():void {
			clear();
			_currentStroke=null;
			_currentPT=0;
			addEventListener(Event.ENTER_FRAME, handleNextStep);
			handleNextStep();
		}
		protected function fixPointCoords(pt:Point):Point {
			var p:Point=new Point((pt.x-_minPoint.x)/(_maxPoint.x-_minPoint.x), (pt.y-_minPoint.y)/(_maxPoint.y-_minPoint.y));
			return _rotate ? new Point(p.y, 1-p.x) : p;
		}
		protected function getPointCoords(pt:Point):Point {
			return new Point(_padding+(size.x-2*_padding)*pt.x, _padding+(size.y-2*_padding)*pt.y);
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
			var length:Number=Point.distance(prevPoint, pt);
			var lengthRatio:Number=Math.min(1, 1-((length-minLineSize)/(maxLineSize-minLineSize)));
			var thickness:Number=minThickness+lengthRatio*(maxThickness-minThickness);
			if (prevPoint) moveTo(prevPoint);
			g.lineStyle(thickness, lineColor);
			g.lineTo(pt.x, pt.y);
			if (storePos) _prevPoint=pt;
			//
			if (drip && Math.random()<=dripProbability) {
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
		public function clear():void {
			g.clear();
			_bc.clear();
			var d:Drip;
			while(_drips.length) d=_drips.pop();
			_prevPoint=new Point();
		}
	}
}