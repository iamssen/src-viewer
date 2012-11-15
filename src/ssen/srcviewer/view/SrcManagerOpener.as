package ssen.srcviewer.view {
import ssen.mvc.IEventBus;
import ssen.srcviewer.view.components.EventTrigger;

public class SrcManagerOpener extends EventTrigger {
	[Embed(source="assets/bottom.srcmanager.normal.png")]
	private static var OpenSrcManagerNormalImage:Class;

	[Embed(source="assets/bottom.srcmanager.down.png")]
	private static var OpenSrcManagerDownImage:Class;

	public function SrcManagerOpener() {
		normal=OpenSrcManagerNormalImage;
		down=OpenSrcManagerDownImage;
	}

	override protected function fireEvent(eventBus:IEventBus):void {
		eventBus.dispatchEvent(new ViewEvent(ViewEvent.OPEN_SRC_MANAGER));
	}
}
}
