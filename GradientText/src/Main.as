package {
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormat;
	import net.tw.text.GradientText;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class Main extends Sprite {
		[Embed(source="impact.ttf", fontFamily="impact")]
		public var fontClass1:String;
		//
		[Embed(source="georgia.ttf", fontFamily="georgia")]
		public var fontClass2:String;
		//
		private var gt:GradientText;
		//
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//
			gt=new GradientText(new TextFormat("georgia", 50), 0xeeeeee, 0x666666);
			gt.filters=[new DropShadowFilter(1, 90, 0, 1, 0, 0)];
			onMove();
			addChild(gt);
			//
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		private function onClick(e:MouseEvent):void {
			gt.setFormat(new TextFormat(gt.getFormat().font=='georgia' ? 'impact' : 'georgia'));
			placeField();
		}
		private function onMove(e:MouseEvent=null):void {
			var f:TextFormat=new TextFormat();
			f.size=stage.mouseX/10;
			gt.text='Gradient text, '+Math.round(f.size as Number)+'px.';
			gt.setFormat(f);
			placeField();
		}
		protected function placeField():void {
			gt.x=(stage.stageWidth-gt.width)/2;
			gt.y=(stage.stageHeight-gt.height)/2;
		}
	}
}