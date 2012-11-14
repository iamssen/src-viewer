package ssen.srcviewer.view.components {
import flash.events.Event;
import flash.events.MouseEvent;

import spark.components.Button;

public class HistoryOpener extends Button {

	public var path:String;
	public var callback:Function;

	public function HistoryOpener() {
		addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true);
	}

	private function removedFromStageHandler(event:Event):void {
		removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		callback=null;
	}

	override protected function clickHandler(event:MouseEvent):void {
		callback(path);
	}
}
}
