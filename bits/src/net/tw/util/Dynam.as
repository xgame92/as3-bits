﻿package net.tw.util {
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class Dynam {
		protected static var _data:Array=[];
		public static function ize(target:*, props:Array, getter:Function, setter:Function):void {
			var funcs:Array=[];
			//
			for (var i:uint=0; i<props.length; i++) {
				var prop:String=props[i];
				var camel:String=prop.substr(0, 1).toUpperCase()+prop.substring(1);
				//
				var _getter:Function=function ():* {
					return getter(getKey(arguments.callee, 'g'));
				};
				var _setter:Function=function (o:Object=null):void {
					setter(getKey(arguments.callee, 's'), o);
				};
				//
				funcs[prop]={g:_getter, s:_setter};
				//
				target['get'+camel]=_getter;
				target['set'+camel]=_setter;
			}
			_data.push(funcs);
		}
		protected static function getKey(f:Function, type:String):String {
			for (var i:uint=0; i<_data.length; i++) {
				var funcs:Array=_data[i];
				for (var prop:String in funcs) if (funcs[prop][type]==f) return prop;
			}
			return null;
		}
	}
}