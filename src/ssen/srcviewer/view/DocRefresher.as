package ssen.srcviewer.view {
import ssen.mvc.IEventBus;
import ssen.srcviewer.view.components.EventTrigger;

public class DocRefresher extends EventTrigger {
	[Embed(source="assets/bottom.refresh.png")]
	private static var RefreshImage:Class;

	public function DocRefresher() {
		normal=RefreshImage;
	}

	override protected function fireEvent(eventBus:IEventBus):void {
		eventBus.dispatchEvent(new ViewEvent(ViewEvent.REFRESH_DOC));
	}
}
}
