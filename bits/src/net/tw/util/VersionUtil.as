package net.tw.util {
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class VersionUtil {
		/**
		 * Determines wether the first version is greater than the second.
		 * @param	v1	Version String
		 * @param	v2	Version String
		 * @return		Returns true if the first version number is greater than the second, or false if it is lesser or indeterminate.
		 * @usage		Works with most common versions strings: ex. 1.0.2.27 < 1.0.3.2, 1.0b3 < 1.0b5, 1.0a12 < 1.0b7, 1.0b3 < 1.0
		 * @see			Code borrowed from AIRInstallBadge.as, by Grant Skinner.
		 * @see			http://www.adobe.com/devnet/air/articles/badge_for_air.html
		 */
		//public static function compare(v1:String,v2:String):int {
		public static function compare(v1:String,v2:String):Boolean {
			var arr1:Array = v1.replace(/^v/i,"").match(/\d+|[^\.,\d\s]+/ig);
			var arr2:Array = v2.replace(/^v/i,"").match(/\d+|[^\.,\d\s]+/ig);
			var l:uint = Math.max(arr1.length,arr2.length);
			for (var i:uint=0; i<l; i++) {
				var sub:int = checkSubVersion(arr1[i],arr2[i])
				if (sub == 0) { continue; }
				//return sub;
				return sub==1;
			}
			//return 0;
			return false;
		}
		// 
		/**
		 * Determines wether the first sub-version is greater than the second.
		 * @param	v1	Version String
		 * @param	v2	Version String
		 * @return		Returns 1 if the sub version element v1 is greater than v2, -1 if v2 is greater than v1, and 0 if they are equal.
		 * @see		#compare()
		 */
		public static function checkSubVersion(v1:String,v2:String):int {
			v1 = (v1 == null) ? "" : v1.toUpperCase();
			v2 = (v2 == null) ? "" : v2.toUpperCase();
			
			if (v1 == v2) { return 0; }
			var num1:Number = parseInt(v1);
			var num2:Number = parseInt(v2);
			if (isNaN(num2) && isNaN(num1)) {
				return (v1 == "") ? 1 : (v2 == "") ? -1 : (v1 > v2) ? 1 : -1;
			}
			else if (isNaN(num2)) { return 1; }
			else if (isNaN(num1)) { return -1; }
			else { return (num1 > num2) ? 1 : -1; }
		}
	}
}