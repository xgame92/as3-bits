package net.tw.util {
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class GraphicMC {
		public static var LOOP:String='Loop';
		public static var PLAY_ONCE:String='Play once';
		public static var SINGLE_FRAME:String='Single frame';
		//
		protected static var _ar:Array=[];
		protected static var _done:Array=[];
		protected static var _depths:Array=[];
		protected static var _mcTimer:MovieClip;
		//
		public static function register(mc:MovieClip, loop:String='Loop', firstFrame:uint=1, appearsAt:uint=0):Boolean {
			// on ne doit gérer un Clip qu'une fois
			if (_done[mc]) return false;
			_done[mc]=true;
			// Le clip dont on va attraper le onEnterFrame
			if (!_mcTimer) {
				_mcTimer=new MovieClip();
				_mcTimer.addEventListener(Event.ENTER_FRAME, globalEF);
			}
			// Le cas le plus simple : l'image unique
			if (loop==SINGLE_FRAME) {
				mc.gotoAndStop(firstFrame);
			} else {
				// on chope la profondeur du clip
				var mcDepth:Number=getDepth(mc);
				// Si cette profondeur n'est pas encore gérée, on l'ajoute
				if (_depths.indexOf(mcDepth)==-1) {
					_depths.push(mcDepth);
					// et on trie le tableau (pour parcourir l'arbo du moins au plus profond)
					_depths.sort();
				}
				// on stocke le clip et ses attributs
				_ar.push({mc:mc, loop:loop, firstFrame:firstFrame, depth: mcDepth, p1:appearsAt==0 ? MovieClip(mc.parent).currentFrame : appearsAt});
			}
			return true;
		}
		public static function resetRegistrations():void {
			_ar=[];
			_done=[];
			_depths=[];
		}
		protected static function globalEF(e:Event=null):void {
			// on va du moins au plus profond...
			for (var i:int=0; i<_depths.length; i++) {
				var curDepth:uint=_depths[i];
				for (var j:int=0; j<_ar.length; j++) {
					var o:Object=_ar[j];
					// si le clip en question n'est pas à la bonne profondeur, on zappe
					if (o.depth!=curDepth) continue;
					// sinon, on gère
					onEF(o.mc, o.loop, o.firstFrame, o.p1);
				}
			}
		}
		protected static function onEF(mc:MovieClip, loop:String, firstFrame:uint, p1:int):void {
			var gap:int=MovieClip(mc.parent).currentFrame-p1;
			var goto:int;
			if (loop==LOOP) goto=((gap+firstFrame-1)%mc.totalFrames)+1;
			else if (loop==PLAY_ONCE) goto=Math.min(gap+firstFrame, mc.totalFrames);
			mc.gotoAndStop(goto);
		}
		public static function getDepth(mc:MovieClip):uint {
			return String(mc).split(".").length-1;
		}
	}
}