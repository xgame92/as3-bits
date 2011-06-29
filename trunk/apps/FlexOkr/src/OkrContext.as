package {
	//import command.UploadCommand;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.Context;
	
	import service.*;
	
	import view.*;
	import view.event.DrawActionEvent;
	
	public class OkrContext extends Context {
		public function OkrContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true) {
			super(contextView, autoStartup);
		}
		override public function startup():void {
			contextView.stage.frameRate=61;
			mediatorMap.mapView(ControlBar, ControlBarMediator);
			mediatorMap.mapView(PlayerHolder, PlayerHolderMediator);
			mediatorMap.mapView(FlexOkr, FlexOkrMediator);
			injector.mapSingleton(GMLSearchService);
			//injector.mapSingleton(GMLUploadService);
			//commandMap.mapEvent(DrawActionEvent.UPLOAD, UploadCommand);
			super.startup();
		}
	}
}