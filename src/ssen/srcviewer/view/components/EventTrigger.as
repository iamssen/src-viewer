package ssen.srcviewer.view.components {
import flash.events.Event;
import flash.events.MouseEvent;

import spark.components.Button;

import ssen.mvc.IDependent;
import ssen.mvc.IEventBus;

public class EventTrigger extends Button implements IDependent {

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
