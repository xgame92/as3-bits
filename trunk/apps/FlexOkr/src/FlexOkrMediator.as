package {
	import mx.controls.Alert;
	
	import org.robotlegs.mvcs.Mediator;
	
	import service.event.UploadEvent;
	
	public class FlexOkrMediator extends Mediator {
		override public function onRegister():void {
			addContextListener(UploadEvent.UPLOAD_SUCCESS, onUploadSuccess);
			addContextListener(UploadEvent.UPLOAD_ERROR, onUploadError);
		}
		protected function onUploadSuccess(e:UploadEvent):void {
			Alert.show('Your graffiti has been uploaded to 000000book.com', 'Success!'); 
		}
		protected function onUploadError(e:UploadEvent):void {
			Alert.show('Error while uploading your graffiti to 000000book.com', 'Error!'); 
		}
	}
}