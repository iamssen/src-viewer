package ssen.srcviewer {
import ssen.mvc.Context;
import ssen.mvc.IContext;
import ssen.mvc.IContextView;
import ssen.srcviewer.commands.OpenDocsLocation;
import ssen.srcviewer.model.DocModel;
import ssen.srcviewer.model.SrcModel;
import ssen.srcviewer.view.DocLocationOpener;
import ssen.srcviewer.view.DocRefresher;
import ssen.srcviewer.view.DocViewer;
import ssen.srcviewer.view.FileChooser;
import ssen.srcviewer.view.FileList;
import ssen.srcviewer.view.FileListRefresher;
import ssen.srcviewer.view.Reader;
import ssen.srcviewer.view.Searcher;
import ssen.srcviewer.view.SearcherOpener;
import ssen.srcviewer.view.SrcManager;
import ssen.srcviewer.view.SrcManagerOpener;
import ssen.srcviewer.view.SrcViewerWindowMediator;
import ssen.srcviewer.view.ViewEvent;

public class SrcViewerWindowContext extends Context {
	private var _srcmodel:SrcModel;

	public function SrcViewerWindowContext(contextView:IContextView, srcmodel:SrcModel, parentContext:IContext=null) {
		_srcmodel=srcmodel;

		super(contextView, parentContext);
	}

	/** @inheritDoc */
	override protected function mapDependency():void {
		injector.mapSingleton(DocModel);
		injector.mapValue(SrcModel, _srcmodel);
		
		injector.injectInto(_srcmodel);
		//		injector.mapSingleton(DocViewer);

		commandMap.mapCommand(ViewEvent.OPEN_DOCS_LOCATION, new <Class>[OpenDocsLocation]);

		//----------------------------------------------------------------
		// view inject :: global
		//----------------------------------------------------------------
		viewInjector.mapView(SrcViewerWindow, SrcViewerWindowMediator);
		viewInjector.mapView(FileChooser);
		viewInjector.mapView(Reader);

		//----------------------------------------------------------------
		// view inject :: reader
		//----------------------------------------------------------------
		// bottom left
		viewInjector.mapView(FileListRefresher);
		viewInjector.mapView(SrcManagerOpener);
		viewInjector.mapView(SearcherOpener);

		// middle left
		viewInjector.mapView(FileList);

		// bottom right
		viewInjector.mapView(DocLocationOpener);
		viewInjector.mapView(DocRefresher);

		// middle right
		viewInjector.mapView(DocViewer);

		//----------------------------------------------------------------
		// view inject :: popups
		//----------------------------------------------------------------
		viewInjector.mapView(SrcManager);
		viewInjector.mapView(Searcher);
	}

	/** @inheritDoc */
	override protected function startup():void {
		eventBus.dispatchEvent(new ViewEvent(_srcmodel.hasSrcViewFile() ? ViewEvent.OPEN_SRC_READER : ViewEvent.OPEN_SRC_VIEW_FILE_CHOOSER));
	}

	/** @inheritDoc */
	override protected function dispose():void {
		super.dispose();

		_srcmodel.dispose();
		_srcmodel=null;
	}
}
}
