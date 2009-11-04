package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import net.tw.util.Dynam;
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
			trace('get abc', dc.getAbc());
			//
			dc.setDef('Ouais, gros.');
			trace('get def', dc.getDef());
			//
			trace('get abc', dc.getAbc());
			trace('get ghi', dc.getGhi());
		}
		protected function getter(key:String):void {
			trace('get', key);
		}
		protected function setter(key:String, val:*):void {
			trace('set', key, val);
		}
	}
}