package net.tw.util {
	public class VersionComparator {
		public static function isNewer(currentVersion:String, updateVersion:String):Boolean {
			currentVersion=trim(currentVersion);
			updateVersion=trim(updateVersion);
			
			if (currentVersion==updateVersion) return false;
			
			var arCurrent:Array=currentVersion.split('.');
			var arUpdate:Array=updateVersion.split('.');
			var maxLength:uint=Math.max(arCurrent.length, arUpdate.length);
			if (arCurrent.length!=maxLength) while (arCurrent.length<maxLength) arCurrent.push('0');
			if (arUpdate.length!=maxLength) while (arUpdate.length<maxLength) arUpdate.push('0');
			
			for (var i:int=0; i<maxLength; i++) {
				if (uint(arCurrent[i])>uint(arUpdate[i])) return false;
				if (uint(arCurrent[i])<uint(arUpdate[i])) return true;
			}
			
			return false;
		}
		protected static function trim(v:String):String {
			return v.replace(/(\.0)+$/g, '');
		}
	}
}