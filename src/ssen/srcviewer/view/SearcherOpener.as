package ssen.srcviewer.view {
import ssen.mvc.IEventBus;
import ssen.srcviewer.view.components.EventTrigger;

public class SearcherOpener extends EventTrigger {
	[Embed(source="assets/bottom.search.normal.png")]
	private static var SearchNormalImage:Class;

	[Embed(source="assets/bottom.search.down.png")]
	private static var SearchDownImage:Class;

	public function SearcherOpener() {
		normal=SearchNormalImage;
		down=SearchDownImage;
	}

	override protected function fireEvent(eventBus:IEventBus):void {
		eventBus.dispatchEvent(new ViewEvent(ViewEvent.OPEN_SEARCHER));
	}
}
}
