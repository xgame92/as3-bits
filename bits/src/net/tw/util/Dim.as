package net.tw.util {
	/**
	* @author Quentin T - http://toki-woki.net
	*/
	public class Dim {
		public static function fitInto(o1:Object, o2:Object):Object {
			var wRatio:Number = o2.width / o1.width;
			var hRatio:Number = o2.height / o1.height;
			//
			var maxRatio:Number = Math.min(wRatio, hRatio);
			//
			var o:Object = { };
			o.width = maxRatio * o1.width;
			o.height = maxRatio * o1.height;
			o.x = (o2.width - o.width) / 2;
			o.y = (o2.height - o.height) / 2;
			//
			return o;
		}
	}
}