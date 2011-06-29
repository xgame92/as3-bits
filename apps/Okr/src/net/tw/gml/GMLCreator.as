package net.tw.gml {
	import com.bit101.components.PushButton;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.*;
	import flash.utils.getTimer;
	
	import net.tw.gml.player.GMLPlayer;
	
	public class GMLCreator {
		public static const APP_NAME:String='Okr';
		public static const UPLOAD_ENDPOINT:String='http://000000book.com/data';
		//
		protected var _player:GMLPlayer;
		//protected var bClear:PushButton;
		//protected var bSend:PushButton;
		protected var _drawingXML:XML;
		protected var _stroke:XML;
		protected var _drawStartTime:int;
		//
		public function GMLCreator(player:GMLPlayer) {
			_player=player;
			//bClear=new PushButton(this, 10, 10, 'Clear', onClear);
			//bSend=new PushButton(this, 10, 40, 'Send', onSend);
			if (stage) addStageEvents();
			else player.addEventListener(Event.ADDED_TO_STAGE, addStageEvents);
			onClear();
		}
		public function get stage():Stage {
			return _player.stage;
		}
		protected function addStageEvents(e:Event=null):void {
			stage.removeEventListener(Event.ADDED_TO_STAGE, addStageEvents);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, startDrawing);
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
		protected function onClear(e:MouseEvent=null):void {
			_player.clear();
			_drawingXML=<drawing />;
			_drawStartTime=0;
		}
		public function get gml():XML {
			return <gml>
					<tag>
						<header>
							<client>
								<name>{APP_NAME}</name>
								<version>0.1</version>
								<keywords>tokiwoki,test</keywords>
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
		protected function onSend(e:MouseEvent=null):void {
			var r:URLRequest=new URLRequest(UPLOAD_ENDPOINT);
			var vars:URLVariables=new URLVariables();
			vars['tag[gml]']=gml.toXMLString();
			vars['tag[application]']=APP_NAME;
			r.method=URLRequestMethod.POST;
			r.data=vars;
			var l:URLLoader=new URLLoader();
			l.addEventListener(Event.COMPLETE, onUploadComplete);
			l.addEventListener(IOErrorEvent.IO_ERROR, onError);
			l.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			l.load(r);
		}
		protected function onUploadComplete(e:Event):void {
			trace('--------Upload complete------------', e.target.data);
		}
		protected function onError(e:IOErrorEvent):void {
			trace(e);
		}
		protected function onStatus(e:HTTPStatusEvent):void {
			trace(e, e.status);
		}
	}
}