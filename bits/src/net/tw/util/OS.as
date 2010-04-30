package net.tw.util {
	import flash.system.Capabilities;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class OS {
		public static function isWindows():Boolean {
			return Capabilities.os.indexOf("Win")==0;
		}
		public static function isMac():Boolean {
			return Capabilities.os.indexOf("Mac")==0;
		}
		public static function isLinux():Boolean {
			return Capabilities.os.indexOf("Linux")==0;
		}
		public static function isIE():Boolean {
			return Capabilities.playerType=='ActiveX';
		}
	}
}