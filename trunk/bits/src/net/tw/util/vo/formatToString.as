package net.tw.util.vo {
	public function formatToString(object:*, className:String, ...properties:Array):String {
		var s:String='['+className;
		var prop:String;
		for (var i:int=0; i<properties.length; i++) {
			prop=properties[i];
			s+=' '+prop+'='+object[prop];
		}
		return s+']';
	}
}