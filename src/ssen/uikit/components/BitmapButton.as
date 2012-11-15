package ssen.uikit.components {
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.MouseEvent;

import spark.core.SpriteVisualElement;

public class BitmapButton extends SpriteVisualElement {
	public var normal:Class;
	public var down:Class;
	private var _normal:BitmapData;
	private var _down:BitmapData;
	private var _w:int;
	private var _h:int;

	public function BitmapButton() {
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}

	private function addedToStageHandler(event:Event):void {
		_normal=new normal().bitmapData;
		if (down !== null) {
			_down=new down().bitmapData;
		}
		_w=_normal.width;
		_h=_normal.height;
		removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		draw(false);
		buttonMode=true;
	}

	private function mouseDownHandler(event:MouseEvent):void {
		removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		draw(true);
	}

	private function mouseUpHandler(event:MouseEvent):void {
		stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		draw(false);
	}

	private function removedFromStageHandler(event:Event):void {
		removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		graphics.clear();
	}

	override public function get width():Number {
		return _w;
	}

	override public function get height():Number {
		return _h;
	}

	private function draw(down:Boolean):void {
		graphics.clear();

		graphics.beginBitmapFill((!down || _down === null) ? _normal : _down);
		graphics.drawRect(0, 0, _w, _h);
		graphics.endFill();
	}
}
}
