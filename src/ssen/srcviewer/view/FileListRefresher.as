package ssen.srcviewer.view {
import ssen.mvc.IEventBus;
import ssen.srcviewer.view.components.EventTrigger;

public class FileListRefresher extends EventTrigger {
	[Embed(source="assets/bottom.refresh.png")]
	private static var RefreshImage:Class;

	public function FileListRefresher() {
		normal=RefreshImage;
	}

	override protected function fireEvent(eventBus:IEventBus):void {
		eventBus.dispatchEvent(new ViewEvent(ViewEvent.REFRESH_LIST));
	}
}
}
