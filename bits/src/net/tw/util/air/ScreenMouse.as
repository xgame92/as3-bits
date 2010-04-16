package net.tw.util.air {
	import flash.display.NativeWindow;
	import flash.display.Stage;
	public class ScreenMouse {
		//public static var stage:Stage;
		public function ScreenMouse() {}
		public static function getNativeWindow(stage:Stage):NativeWindow {
			return stage.nativeWindow;
		}
		public static function getNativeWindowLeftMargin(stage:Stage):Number {
			return (stage.nativeWindow.width-stage.stageWidth)/2;
		}
		public static function getNativeWindowTopMargin(stage:Stage):Number {
			return stage.nativeWindow.height-stage.stageHeight-getNativeWindowLeftMargin(stage);
		}
		public static function getX(stage:Stage):int {
			return stage.nativeWindow.x+stage.mouseX+getNativeWindowLeftMargin(stage);
		}
		public static function getY(stage:Stage):int {
			return stage.nativeWindow.y+stage.mouseY+getNativeWindowTopMargin(stage);
		}
	}
}