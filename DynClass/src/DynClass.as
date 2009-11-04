package {
	import net.tw.util.Dynam;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	// This is my class, that has to be dynamic
	public dynamic class DynClass {
		protected var _data:Array=[];
		public function DynClass() {
			// In the constructor I call the Dynam.ize method on this, so it builds the getters and setters for the supplied properties
			Dynam.ize(this, ['abc', 'def', 'ghi'], getter, setter);
		}
		// Here are the functions that will be called when I try to get or set one of the properties I listed in Dynam.ize
		protected function getter(key:String):* {
			return _data[key];
		}
		protected function setter(key:String, v:*):void {
			_data[key]=v;
		}
	}
}