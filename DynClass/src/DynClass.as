package  {
	import net.tw.util.Dynam;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public dynamic class DynClass{
		protected var _data:Array=[];
		public function DynClass() {
			Dynam.ize(this, ['abc', 'def', 'ghi'], getter, setter);
		}
		protected function getter(key:String):* {
			return _data[key];
		}
		protected function setter(key:String, v:*):void {
			_data[key]=v;
		}
	}
}