package ssen.srcviewer.view {
import mx.core.IVisualElement;
import mx.managers.PopUpManager;

import ssen.mvc.IEventBus;
import ssen.mvc.IMediator;
import ssen.mvc.IViewOuterBridge;
import ssen.srcviewer.SrcViewerWindow;

public class SrcViewerWindowMediator implements IMediator {
	[Inject]
	public var eventBus:IEventBus;

	[Inject]
	public var viewOuterBridge:IViewOuterBridge;

	private var view:SrcViewerWindow;
	private var subView:IVisualElement;

	private var srcManager:SrcManager;
	private var searcher:Searcher;

	public function setView(value:Object):void {
		view=value as SrcViewerWindow;
	}

	public function onRegister():void {
		eventBus.addEventListener(ViewEvent.OPEN_SRC_VIEW_FILE_CHOOSER, openSrcViewFileChooser);
		eventBus.addEventListener(ViewEvent.OPEN_SRC_READER, openSrcReader);
		eventBus.addEventListener(ViewEvent.OPEN_SRC_MANAGER, openSrcManager);
		eventBus.addEventListener(ViewEvent.OPEN_SEARCHER, openSearcher);
	}

	public function onRemove():void {
		eventBus.removeEventListener(ViewEvent.OPEN_SRC_VIEW_FILE_CHOOSER, openSrcViewFileChooser);
		eventBus.removeEventListener(ViewEvent.OPEN_SRC_READER, openSrcReader);
		eventBus.removeEventListener(ViewEvent.OPEN_SRC_MANAGER, openSrcManager);
		eventBus.removeEventListener(ViewEvent.OPEN_SEARCHER, openSearcher);
	}

	private function openSearcher(event:ViewEvent):void {
		if (searcher !== null) {
			return;
		}
		
		searcher=new Searcher;
		
		viewOuterBridge.ready(searcher);
		
		PopUpManager.addPopUp(searcher, view);
		PopUpManager.centerPopUp(searcher);
		
		eventBus.removeEventListener(ViewEvent.OPEN_SEARCHER, openSearcher);
		eventBus.addEventListener(ViewEvent.CLOSE_SEARCHER, closeSearcher);
	}
	
	private function closeSearcher(event:ViewEvent):void
	{
		if (searcher) {
			eventBus.removeEventListener(ViewEvent.CLOSE_SEARCHER, closeSearcher);
			eventBus.addEventListener(ViewEvent.OPEN_SEARCHER, openSearcher);
			
			PopUpManager.removePopUp(searcher);
			
			searcher=null;
		}
	}
	
	private function openSrcManager(event:ViewEvent):void {
		srcManager=new SrcManager;

		viewOuterBridge.ready(srcManager);

		PopUpManager.addPopUp(srcManager, view, true);
		PopUpManager.centerPopUp(srcManager);

		eventBus.removeEventListener(ViewEvent.OPEN_SRC_MANAGER, openSrcManager);
		eventBus.addEventListener(ViewEvent.CLOSE_SRC_MANAGER, closeSrcManager);
	}

	private function closeSrcManager(event:ViewEvent):void {
		if (srcManager) {
			eventBus.removeEventListener(ViewEvent.CLOSE_SRC_MANAGER, closeSrcManager);
			eventBus.addEventListener(ViewEvent.OPEN_SRC_MANAGER, openSrcManager);

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
