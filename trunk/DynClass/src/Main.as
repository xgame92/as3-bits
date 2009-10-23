package {
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class Main extends Sprite {
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			var dc:DynClass=new DynClass();
			dc.setAbc('aaa');
			trace('get!', dc.getAbc());
			//
			dc.setDef('Ouais, gros.');
			trace(dc.getDef());
			//
			trace(dc.getAbc());
			trace(dc.getGhi());
			//trace(dc.blabla());
		}
	}
}