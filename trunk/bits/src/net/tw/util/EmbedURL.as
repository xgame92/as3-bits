package net.tw.util {
	import flash.external.ExternalInterface;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class EmbedURL {
		public static function query():String {
			if (!ExternalInterface.available) return null;
			var s:String;
			try {s=ExternalInterface.call('window.location.href.toString');} catch (er:Error) {}
			try {if (!s) s=ExternalInterface.call('eval', 'document.location.href');} catch (er:Error) {}
			return s;
		}
	}
}