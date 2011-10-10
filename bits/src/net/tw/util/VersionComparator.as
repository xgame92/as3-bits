package net.tw.util {
	public class VersionComparator {
		public static function isNewer(currentVersion:String, updateVersion:String):Boolean {
			currentVersion=trim(currentVersion);
			updateVersion=trim(updateVersion);
			
			if (currentVersion==updateVersion) return false;
			
			var ar1:Array=currentVersion.split('.');
			var ar2:Array=updateVersion.split('.');
			var maxLength:uint=Math.max(ar1.length, ar2.length);
			if (ar1.length!=maxLength) while (ar1.length<maxLength) ar1.push('0');
			if (ar2.length!=maxLength) while (ar2.length<maxLength) ar2.push('0');
			
			for (var i:int=0; i<maxLength; i++) {
				if (uint(ar1[i])>uint(ar2[i])) return false;
				if (uint(ar1[i])<uint(ar2[i])) return true;
			}
			
			return false;
		}
		protected static function trim(v:String):String {
			return v.replace(/(\.0)+$/g, '');
		}
	}
}