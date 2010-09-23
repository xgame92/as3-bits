package command {
	import org.robotlegs.mvcs.Command;
	
	import service.GMLUploadService;
	
	import view.event.DrawActionEvent;
	
	public class UploadCommand extends Command {
		[Inject]
		public var event:DrawActionEvent;
		[Inject]
		public var uploadService:GMLUploadService;
		public function UploadCommand() {
			super();
		}
		override public function execute():void {
			uploadService.upload(event.gml, event.appName);
		}
	}
}