package view {
	import com.asual.swfaddress.SWFAddress;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	import service.GMLSearchService;
	import service.event.GMLSearchResultEvent;
	
	import spark.events.IndexChangeEvent;
	
	import view.event.*;
	
	public class ControlBarMediator extends Mediator {
		[Inject]
		public var controlBar:ControlBar;
		[Inject]
		public var searchService:GMLSearchService;
		//
		override public function onRegister():void {
			controlBar.slMin.addEventListener(Event.CHANGE, onSlider);
			controlBar.slMax.addEventListener(Event.CHANGE, onSlider);
			controlBar.slDrips.addEventListener(Event.CHANGE, onSlider);
			//
			controlBar.btnSearch.addEventListener(MouseEvent.CLICK, onSearch);
			controlBar.tiSearch.addEventListener(FlexEvent.ENTER, onSearch);
			//
			controlBar.ddRes.visible=false;
			addContextListener(GMLSearchResultEvent.RESULTS_READY, onSearchResults);
			controlBar.ddRes.addEventListener(IndexChangeEvent.CHANGE, onTagSelection);
			/*controlBar.vs.addEventListener(IndexChangedEvent.CHANGE, onToolChange);
			//
			controlBar.btnDone.addEventListener(MouseEvent.CLICK, onDrawBtn);
			controlBar.btnClear.addEventListener(MouseEvent.CLICK, onDrawBtn);
			controlBar.btnSubmit.addEventListener(MouseEvent.CLICK, onDrawBtn);
			controlBar.btnClear.enabled=controlBar.btnSubmit.enabled=false;*/
		}
		protected function onSlider(e:Event):void {
			dispatch(new InkSettingEvent(InkSettingEvent.CHANGE, controlBar.slMin.value, controlBar.slMax.value, controlBar.slDrips.value/100));
		}
		protected function onSearch(e:Event):void {
			if (!controlBar.btnSearch.enabled) return;
			controlBar.ddRes.visible=false;
			controlBar.lblNbRes.text='Loading...';
			searchService.search(controlBar.tiSearch.text);
		}
		protected function onSearchResults(e:GMLSearchResultEvent):void {
			controlBar.ddRes.dataProvider=new ArrayList(e.results);
			controlBar.ddRes.selectedIndex=0;
			controlBar.ddRes.visible=true;
			controlBar.lblNbRes.text=e.results.length-2+' results';
			onTagSelection();
		}
		protected function onTagSelection(e:IndexChangeEvent=null):void {
			SWFAddress.setValue('play/'+controlBar.ddRes.selectedItem);
			//dispatch(new TagSelectionEvent(TagSelectionEvent.SELECT, controlBar.ddRes.selectedItem));
		}
		/*protected function onToolChange(e:IndexChangedEvent):void {
			if (controlBar.vs.selectedChild==controlBar.ncPlay) {
				controlBar.btnDone.enabled=true;
				controlBar.btnClear.enabled=false;
				controlBar.btnSubmit.enabled=false;
			}
			dispatch(new ModeChangeEvent(ModeChangeEvent.MODE_CHANGE, controlBar.vs.selectedChild==controlBar.ncPlay ? ModeChangeEvent.PLAY_MODE : ModeChangeEvent.DRAW_MODE));
		}
		protected function onDrawBtn(e:MouseEvent):void {
			var type:String;
			if (e.target==controlBar.btnDone) {
				type=DrawActionEvent.DONE;
				controlBar.btnDone.enabled=false;
				controlBar.btnClear.enabled=true;
				controlBar.btnSubmit.enabled=true;
			}
			if (e.target==controlBar.btnClear) {
				type=DrawActionEvent.CLEAR;
				controlBar.btnDone.enabled=true;
				controlBar.btnClear.enabled=false;
				controlBar.btnSubmit.enabled=false;
			}
			if (e.target==controlBar.btnSubmit) type=DrawActionEvent.SUBMIT;
			dispatch(new DrawActionEvent(type, controlBar.tiKeywords.text));
		}*/
	}
}