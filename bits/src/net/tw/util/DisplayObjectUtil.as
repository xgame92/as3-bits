package net.tw.util {
	import flash.display.DisplayObject;
	//
	public class DisplayObjectUtil {
		public static function isVisible(o:DisplayObject):Boolean {
			if (!o.stage) return false;
			var p:DisplayObject=o;
			while(p!=p.stage) {
				if (!p.visible) return false;
				p=p.parent;
			}
			return true;
		}
	}
}