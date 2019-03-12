package ssen.srcviewer.view {
import mx.core.IVisualElement;
import mx.managers.PopUpManager;

import ssen.mvc.EvtGatherer;
import ssen.mvc.IEventBus;
import ssen.mvc.IMediator;
import ssen.srcviewer.SrcViewerWindow;
import ssen.srcviewer.model.DocEvent;
import ssen.srcviewer.model.DocModel;

public class SrcViewerWindowMediator implements IMediator {
	[Inject]
	public var eventBus:IEventBus;
	
	[Inject]
	public var docmodel:DocModel;
	
	private var view:SrcViewerWindow;
	private var subView:IVisualElement;
	private var srcManager:SrcManager;
	
	private var evtUnits:EvtGatherer;
	
	public function setView(value:Object):void {
		view=value as SrcViewerWindow;
	}
	
	public function onRegister():void {
		evtUnits=new EvtGatherer;
		evtUnits.add(eventBus.addEventListener(ViewEvent.OPEN_SRC_VIEW_FILE_CHOOSER, openSrcViewFileChooser));
		evtUnits.add(eventBus.addEventListener(ViewEvent.OPEN_SRC_READER, openSrcReader));
		evtUnits.add(eventBus.addEventListener(ViewEvent.OPEN_SRC_MANAGER, openSrcManager));
		evtUnits.add(eventBus.addEventListener(DocEvent.CHANGED_DOC, changedDoc));
	}
	
	public function onRemove():void {
		evtUnits.dispose();
		evtUnits=null;
	}
	
	private function changedDoc(event:DocEvent):void {
		view.title=docmodel.currentDoc.namespace;
	}
	
	private function openSrcManager(event:ViewEvent):void {
		srcManager=new SrcManager;
		
		PopUpManager.addPopUp(srcManager, view, true);
		PopUpManager.centerPopUp(srcManager);
		
		evtUnits.remove(ViewEvent.OPEN_SRC_MANAGER);
		evtUnits.add(eventBus.addEventListener(ViewEvent.CLOSE_SRC_MANAGER, closeSrcManager));
	}
	
	private function closeSrcManager(event:ViewEvent):void {
		if (srcManager) {
			evtUnits.remove(ViewEvent.CLOSE_SRC_MANAGER);
			evtUnits.add(eventBus.addEventListener(ViewEvent.OPEN_SRC_MANAGER, openSrcManager));
			
			PopUpManager.removePopUp(srcManager);
			
			srcManager=null;
			
			eventBus.dispatchEvent(new ViewEvent(ViewEvent.REFRESH_LIST));
		}
	}
	
	private function openSrcReader(event:ViewEvent):void {
		openSubView(Reader);
	}
	
	private function openSrcViewFileChooser(event:ViewEvent):void {
		openSubView(FileChooser);
	}
	
	private function openSubView(viewClass:Class):void {
		closeSubView();
		
		subView=new viewClass();
		subView.percentWidth=100;
		subView.percentHeight=100;
		view.addElement(subView);
	}
	
	private function closeSubView():void {
		if (subView) {
			view.removeElement(subView);
			subView=null;
		}
	}
}
}
