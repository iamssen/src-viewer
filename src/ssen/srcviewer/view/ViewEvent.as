package ssen.srcviewer.view {
import ssen.mvc.Evt;

public class ViewEvent extends Evt {
	public static const OPEN_SRC_VIEW_FILE_CHOOSER:String="openSrcViewFileChooser";
	public static const OPEN_SRC_READER:String="openSrcReader";
	public static const REFRESH_LIST:String="refreshList";
	public static const OPEN_SRC_MANAGER:String="openSrcManager";
	public static const CLOSE_SRC_MANAGER:String="closeSrcManager";
	public static const OPEN_DOCS_LOCATION:String="openDocsLocation";
	public static const REFRESH_DOC:String="refreshDoc";
	
	public function ViewEvent(type:String) {
		super(type);
	}
}
}
