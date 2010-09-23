package net.tw.gml {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.*;
	import flash.utils.getTimer;
	
	import net.tw.gml.player.GMLPlayer;
	
	
	public class GMLCreator {
		protected var _player:GMLPlayer;
		protected var _drawingXML:XML;
		protected var _stroke:XML;
		protected var _drawStartTime:int;
		//
		public function GMLCreator(player:GMLPlayer) {
			_player=player;
		}
		public function get stage():Stage {
			return _player.stage;
		}
		protected function addEvents(e:Event=null):void {
			_player.addEventListener(MouseEvent.MOUSE_DOWN, startDrawing);
		}
		protected function removeEvents():void {
			_player.removeEventListener(MouseEvent.MOUSE_DOWN, startDrawing);
		}
		public function activate():void {
			_player.ignoreSettings=true;
			addEvents();
			clear();
		}
		public function deactivate():void {
			_player.ignoreSettings=false;
			removeEvents();
		}
		protected function startDrawing(e:MouseEvent):void {
			if (e.target!=e.currentTarget) return;
			_stroke=<stroke />;
			if (_drawStartTime==0) _drawStartTime=getTimer();
			_drawingXML.appendChild(_stroke);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDrawing);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, doDraw);
			_player.moveToMouse();
		}
		protected function doDraw(e:MouseEvent):void {
			var p:Point=_player.lineToMouse();
			var pt:XML=<pt>
				<x>{p.x/_player.size.x}</x>
				<y>{p.y/_player.size.y}</y>
				<time>{(getTimer()-_drawStartTime)/1000}</time>
			</pt>;
			_stroke.appendChild(pt);
		}
		protected function stopDrawing(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, doDraw);
		}
		public function clear(e:MouseEvent=null):void {
			_player.stop();
			_drawingXML=<drawing />;
			_drawStartTime=0;
		}
		public function getGML(appName:String='TW-GML Creator', keywords:String=''):XML {
			return <gml>
					<tag>
						<header>
							<client>
								<name>{appName}</name>
								<version>0.1</version>
								<keywords>{keywords}</keywords>
							</client>
							<environment>
								<screenBounds>
									<x>{_player.size.x}</x>
									<y>{_player.size.y}</y>
								</screenBounds>
							</environment>
						</header>
						{_drawingXML}
				</tag>
			</gml>;
		}
	}
}