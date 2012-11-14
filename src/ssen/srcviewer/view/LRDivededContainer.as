package ssen.srcviewer.view {

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import mx.core.IVisualElement;

import spark.components.Group;

public class LRDivededContainer extends Group {

	public var minLeft:int=100;
	public var maxLeft:int=300;

	private var resizer:IVisualElement;
	private var th:int=50;
	private var bh:int=50;
	private var lw:int=200;
	private var tl:Rectangle=new Rectangle;
	private var tr:Rectangle=new Rectangle;
	private var ml:Rectangle=new Rectangle;
	private var mr:Rectangle=new Rectangle;
	private var bl:Rectangle=new Rectangle;
	private var br:Rectangle=new Rectangle;
	private var _dx:Number;
	private var _rx:Number;

	public function LRDivededContainer(left:int=200, top:int=50, bottom:int=50) {
		lw=left;
		th=top;
		bh=bottom;

		addEventListener(Event.ADDED_TO_STAGE, initializeContainer, false, 0, true);
	}

	private function initializeContainer(event:Event):void {
		resizer=getResizer();
		resizer.addEventListener(MouseEvent.MOUSE_DOWN, resizerDownHandler);
		resizer.x=lw;
		resizer.y=stage.stageHeight - int(bh / 2);
		addElement(resizer);

		removeEventListener(Event.ADDED_TO_STAGE, initializeContainer);
		stage.addEventListener(Event.RESIZE, stageResize);
		addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);

		startup();
		measurementSpaces();
	}

	private function removeFromStage(event:Event):void {
		removeElement(resizer);
		resizer.removeEventListener(MouseEvent.MOUSE_DOWN, resizerDownHandler);
		resizer=null;

		stage.removeEventListener(Event.RESIZE, stageResize);
		removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
		shutdown();
	}

	private function stageResize(event:Event):void {
		measurementSpaces();
	}

	private function measurementSpaces():void {
		var rw:int=stage.stageWidth - lw;
		var mh:int=stage.stageHeight - th - bh;

		tl.x=0;
		tl.y=0;
		tl.width=lw;
		tl.height=th;

		tr.x=lw;
		tr.y=0;
		tr.width=rw;
		tr.height=th;

		ml.x=0;
		ml.y=th;
		ml.width=lw;
		ml.height=mh;

		mr.x=lw;
		mr.y=th;
		mr.width=rw;
		mr.height=mh;

		bl.x=0;
		bl.y=th + mh;
		bl.width=lw;
		bl.height=bh;

		br.x=lw;
		br.y=th + mh;
		br.width=rw;
		br.height=bh;

		resizer.y=stage.stageHeight - int(bh / 2);

		invalidateDisplayList();
	}

	/** @inheritDoc */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		updateSpaceOfTopLeft(tl);
		updateSpaceOfTopRight(tr);
		updateSpaceOfMiddleLeft(ml);
		updateSpaceOfMiddleRight(mr);
		updateSpaceOfBottomLeft(bl);
		updateSpaceOfBottomRight(br);
	}

	protected function getResizer():IVisualElement {
		throw new Error("not implemented");
	}

	protected function startup():void {

	}

	protected function shutdown():void {

	}

	protected function updateSpaceOfTopLeft(space:Rectangle):void {

	}

	protected function updateSpaceOfTopRight(space:Rectangle):void {

	}

	protected function updateSpaceOfMiddleLeft(space:Rectangle):void {

	}

	protected function updateSpaceOfMiddleRight(space:Rectangle):void {

	}

	protected function updateSpaceOfBottomLeft(space:Rectangle):void {

	}

	protected function updateSpaceOfBottomRight(space:Rectangle):void {

	}

	private function resizerDownHandler(event:MouseEvent):void {
		_dx=event.stageX;
		_rx=resizer.x;

		resizer.removeEventListener(MouseEvent.MOUSE_DOWN, resizerDownHandler);

		stage.addEventListener(MouseEvent.MOUSE_MOVE, resizerMoveHandler);
		stage.addEventListener(MouseEvent.MOUSE_UP, resizerUpHandler);
	}

	private function resizerUpHandler(event:MouseEvent):void {
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, resizerMoveHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, resizerUpHandler);

		resizer.addEventListener(MouseEvent.MOUSE_DOWN, resizerDownHandler);
	}

	private function resizerMoveHandler(event:MouseEvent):void {
		var tx:int=event.stageX - _dx;
		lw=_rx + tx;

		if (lw < minLeft) {
			lw=minLeft;
		} else if (lw > maxLeft) {
			lw=maxLeft;
		}

		resizer.x=lw;

		measurementSpaces();

		//		event.updateAfterEvent();
	}

}
}
