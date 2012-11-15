package ssen.srcviewer.view.components {
import flash.events.Event;
import flash.events.MouseEvent;

import ssen.mvc.IDependent;
import ssen.mvc.IEventBus;
import ssen.uikit.components.BitmapButton;

public class EventTrigger extends BitmapButton implements IDependent {

	[Inject]
	public var eventBus:IEventBus;

	public function onDependent():void {
		addEventListener(MouseEvent.CLICK, mouseClickHandler);
		addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
	}

	private function removedFromStageHandler(event:Event):void {
		removeEventListener(MouseEvent.CLICK, mouseClickHandler);
		removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);

		eventBus=null;
	}

	private function mouseClickHandler(event:MouseEvent):void {
		fireEvent(eventBus);
	}

	protected function fireEvent(eventBus:IEventBus):void {
		throw new Error("not implements");
	}
}
}
