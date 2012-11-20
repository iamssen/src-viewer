package ssen.srcviewer.view {
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import mx.events.FlexEvent;

import spark.components.TextInput;
import spark.events.TextOperationEvent;

import ssen.mvc.IEventBus;
import ssen.srcviewer.model.SearchModel;
import ssen.srcviewer.view.skins.SearcherSkin;

public class Searcher extends TextInput {
	[Inject]
	public var eventBus:IEventBus;

	[Inject]
	public var searchmodel:SearchModel;

	public function Searcher() {
		addEventListener(FlexEvent.CREATION_COMPLETE, init);
		setStyle("skinClass", SearcherSkin);
		setStyle("focusSkin", null);
	}

	private function init(event:FlexEvent):void {
		removeEventListener(FlexEvent.CREATION_COMPLETE, init);

		addEventListener(TextOperationEvent.CHANGE, textChanged);
		addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		eventBus.addEventListener(ViewEvent.CLOSE_SRC_MANAGER, closeSrcManager);
		stage.addEventListener(KeyboardEvent.KEY_UP, stageKeyUp);
	}

	private function stageKeyUp(event:KeyboardEvent):void {
		if (event.controlKey && event.keyCode === Keyboard.F) {
			focusManager.setFocus(this);
		}
	}

	private function textChanged(event:TextOperationEvent):void {
		searchmodel.keyword=text;
	}

	private function removedFromStageHandler(event:Event):void {
		removeEventListener(TextOperationEvent.CHANGE, textChanged);
		removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		eventBus.removeEventListener(ViewEvent.CLOSE_SRC_MANAGER, closeSrcManager);
		stage.removeEventListener(KeyboardEvent.KEY_UP, stageKeyUp);
	}

	private function closeSrcManager(event:ViewEvent):void {
		text="";
		searchmodel.keyword="";
	}
}
}
