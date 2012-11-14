package ssen.srcviewer.view {
import flash.events.Event;

public class ViewEvent extends Event {
	public static const OPEN_SRC_VIEW_FILE_CHOOSER:String="openSrcViewFileChooser";
	public static const OPEN_SRC_READER:String="openSrcReader";
	public static const REFRESH_LIST:String="refreshList";
	public static const OPEN_SRC_MANAGER:String="openSrcManager";
	public static const CLOSE_SRC_MANAGER:String="closeSrcManager";
	public static const OPEN_DOCS_LOCATION:String="openDocsLocation";
	public static const REFRESH_DOC:String="refreshDoc";

	public function ViewEvent(type:String) {
		super(type, false, false);
	}

	override public function clone():Event {
		return new ViewEvent(type);
	}
}
}
