package ssen.srcviewer.view {
import ssen.mvc.IEventBus;
import ssen.srcviewer.view.components.EventTrigger;

public class DocLocationOpener extends EventTrigger {
	[Embed(source="assets/bottom.openfolder.normal.png")]
	private static var OpenFolderNormalImage:Class;

	[Embed(source="assets/bottom.openfolder.down.png")]
	private static var OpenFolderDownImage:Class;

	public function DocLocationOpener() {
		normal=OpenFolderNormalImage;
		down=OpenFolderDownImage;
	}

	override protected function fireEvent(eventBus:IEventBus):void {
		eventBus.dispatchEvent(new ViewEvent(ViewEvent.OPEN_DOCS_LOCATION));
	}
}
}
