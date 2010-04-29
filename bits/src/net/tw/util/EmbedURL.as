package net.tw.util {
	import flash.external.ExternalInterface;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class EmbedURL {
		public static function query():String {
			if (!ExternalInterface.available) return null;
			var s:String;
			s=ExternalInterface.call('window.location.href.toString');
			if (!s) s=ExternalInterface.call('eval', 'document.location.href');
			return s;
		}
	}
}