package net.tw.util.air {
	import flash.display.NativeWindow;
	import flash.display.Stage;
	public class ScreenMouse {
		public static var stage:Stage;
		public function ScreenMouse() {}
		public static function get nativeWindow():NativeWindow {
			return stage.nativeWindow;
		}
		public static function get nativeWindowLeftMargin():Number {
			return (nativeWindow.width-stage.stageWidth)/2;
		}
		public static function get nativeWindowTopMargin():Number {
			return nativeWindow.height-stage.stageHeight-nativeWindowLeftMargin;
		}
		public static function get x():int {
			return nativeWindow.x+stage.mouseX+nativeWindowLeftMargin;
		}
		public static function get y():int {
			return nativeWindow.y+stage.mouseY+nativeWindowTopMargin;
		}
	}
}