package ssen.srcviewer.view {
import flash.display.Shape;
import flash.geom.Rectangle;

import mx.core.IVisualElement;

import spark.components.VScrollBar;
import spark.core.SpriteVisualElement;

import ssen.common.MathUtils;
import ssen.srcviewer.view.skins.SimpleVScrollBarSkin;

public class Reader extends LRDivededContainer {
	private var tls:Shape;
	private var trs:Shape;
	private var mls:Shape;
	private var mrs:Shape;
	private var bls:Shape;
	private var brs:Shape;
	private var container:SpriteVisualElement;
	private var fileListRefresh:FileListRefresher;
	private var fileList:FileList;
	private var fileListScrollbar:VScrollBar;
	private var srcManagerOpener:SrcManagerOpener;
	private var docLocationOpener:DocLocationOpener;
	private var docRefresher:DocRefresher;
	private var docViewer:DocViewer;

	public function Reader() {
		super(280, 30, 50);
		minLeft=200;
		maxLeft=370;
	}

	/** @inheritDoc */
	override protected function startup():void {
		//----------------------------------------------------------------
		// test backgrounds
		//----------------------------------------------------------------
		tls=new Shape;
		tls.graphics.beginFill(MathUtils.rand(0x000000, 0xffffff));
		tls.graphics.drawRect(0, 0, 10, 10);
		tls.graphics.endFill();
		trs=new Shape;
		trs.graphics.beginFill(MathUtils.rand(0x000000, 0xffffff));
		trs.graphics.drawRect(0, 0, 10, 10);
		trs.graphics.endFill();
		mls=new Shape;
		mls.graphics.beginFill(MathUtils.rand(0x000000, 0xffffff));
		mls.graphics.drawRect(0, 0, 10, 10);
		mls.graphics.endFill();
		mrs=new Shape;
		mrs.graphics.beginFill(MathUtils.rand(0x000000, 0xffffff));
		mrs.graphics.drawRect(0, 0, 10, 10);
		mrs.graphics.endFill();
		bls=new Shape;
		bls.graphics.beginFill(MathUtils.rand(0x000000, 0xffffff));
		bls.graphics.drawRect(0, 0, 10, 10);
		bls.graphics.endFill();
		brs=new Shape;
		brs.graphics.beginFill(MathUtils.rand(0x000000, 0xffffff));
		brs.graphics.drawRect(0, 0, 10, 10);
		brs.graphics.endFill();

		container=new SpriteVisualElement;
		container.addChild(tls);
		container.addChild(trs);
		container.addChild(mls);
		container.addChild(mrs);
		container.addChild(bls);
		container.addChild(brs);
		addElementAt(container, 0);

		//----------------------------------------------------------------
		// parts
		//----------------------------------------------------------------
		// middle left
		fileList=new FileList;
		fileListScrollbar=new VScrollBar;
		fileListScrollbar.viewport=fileList;
		fileListScrollbar.setStyle("skinClass", SimpleVScrollBarSkin);
		addElement(fileList);
		addElement(fileListScrollbar);

		// bottom left
		fileListRefresh=new FileListRefresher;
		srcManagerOpener=new SrcManagerOpener;
		addElement(fileListRefresh);
		addElement(srcManagerOpener);

		// bottom right
		docLocationOpener=new DocLocationOpener;
		docRefresher=new DocRefresher;
		addElement(docLocationOpener);
		addElement(docRefresher);

		// middle right
		docViewer=new DocViewer;
		addElement(docViewer);
	}

	/** @inheritDoc */
	override protected function shutdown():void {
		container.removeChild(tls);
		tls.graphics.clear();
		tls=null;
		container.removeChild(trs);
		trs.graphics.clear();
		trs=null;
		container.removeChild(mls);
		mls.graphics.clear();
		mls=null;
		container.removeChild(mrs);
		mrs.graphics.clear();
		mrs=null;
		container.removeChild(bls);
		bls.graphics.clear();
		bls=null;
		container.removeChild(brs);
		brs.graphics.clear();
		brs=null;


		removeAllElements();

		container=null;

		// middle left
		fileList=null;
		fileListScrollbar=null;

		// bottom left
		fileListRefresh=null;
		srcManagerOpener=null;

		// bottom right
		docLocationOpener=null;
		docRefresher=null;
	}

	override protected function updateSpaceOfBottomLeft(space:Rectangle):void {
		bls.x=space.x;
		bls.y=space.y;
		bls.width=space.width;
		bls.height=space.height;

		fileListRefresh.x=space.x + 10;
		fileListRefresh.y=space.y + int(space.height / 2) - int(fileListRefresh.height / 2);

		srcManagerOpener.x=space.x + int(space.width / 2) - int(srcManagerOpener.width / 2);
		srcManagerOpener.y=space.y + int(space.height / 2) - int(srcManagerOpener.height / 2);
	}

	override protected function updateSpaceOfBottomRight(space:Rectangle):void {
		brs.x=space.x;
		brs.y=space.y;
		brs.width=space.width;
		brs.height=space.height;

		docRefresher.x=space.x + space.width - docRefresher.width - 10;
		docRefresher.y=space.y + int(space.height / 2) - int(docRefresher.height / 2);

		docLocationOpener.x=space.x + int(space.width / 2) - int(docLocationOpener.width / 2);
		docLocationOpener.y=space.y + int(space.height / 2) - int(docLocationOpener.height / 2);
	}

	override protected function updateSpaceOfMiddleLeft(space:Rectangle):void {
		mls.x=space.x;
		mls.y=space.y;
		mls.width=space.width;
		mls.height=space.height;

		fileList.x=space.x;
		fileList.y=space.y;
		fileList.width=space.width;
		fileList.height=space.height;

		fileListScrollbar.x=space.x + space.width - fileListScrollbar.width;
		fileListScrollbar.y=space.y;
		fileListScrollbar.height=space.height;
	}

	override protected function updateSpaceOfMiddleRight(space:Rectangle):void {
		mrs.x=space.x;
		mrs.y=space.y;
		mrs.width=space.width;
		mrs.height=space.height;

		docViewer.x=space.x;
		docViewer.y=space.y;
		docViewer.width=space.width;
		docViewer.height=space.height;

		//		docViewer.viewport.x=space.x;
		//		docViewer.viewport.y=space.y;
		//		docViewer.viewport.width=space.width;
		//		docViewer.viewport.height=space.height;
		//		docViewer.refreshViewport();
	}

	override protected function updateSpaceOfTopLeft(space:Rectangle):void {
		tls.x=space.x;
		tls.y=space.y;
		tls.width=space.width;
		tls.height=space.height;
	}

	override protected function updateSpaceOfTopRight(space:Rectangle):void {
		trs.x=space.x;
		trs.y=space.y;
		trs.width=space.width;
		trs.height=space.height;
	}

	override protected function getResizer():IVisualElement {
		var sp:SpriteVisualElement=new SpriteVisualElement;
		sp.graphics.beginFill(0x000000);
		sp.graphics.drawCircle(0, 0, 10);
		sp.graphics.endFill();
		return sp;
	}
}
}
