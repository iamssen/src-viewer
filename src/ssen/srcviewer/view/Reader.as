package ssen.srcviewer.view {
import flash.display.BitmapData;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Rectangle;

import mx.core.IVisualElement;
import mx.graphics.SolidColor;

import spark.components.VScrollBar;
import spark.core.SpriteVisualElement;
import spark.primitives.BitmapImage;
import spark.primitives.Rect;

import ssen.common.MathUtils;
import ssen.srcviewer.view.skins.SimpleVScrollBarSkin;

public class Reader extends LRQuadDividedContainer {
	[Embed(source="assets/bottom.background.png")]
	public static var BottomBGImage:Class;

	[Embed(source="assets/bottom.resizer.png")]
	public static var BottomResizerImage:Class;

	private var bottomBackground:BitmapImage;

	private var fileListRefresh:FileListRefresher;
	private var fileList:FileList;
	private var fileListScrollbar:VScrollBar;
	private var srcManagerOpener:SrcManagerOpener;
	private var docLocationOpener:DocLocationOpener;
	private var docRefresher:DocRefresher;
	private var docViewer:DocViewer;
	private var leftBackground:Rect;
	private var leftLine:Rect;

	public function Reader() {
		super(300, 29);
		minLeft=200;
		maxLeft=370;
	}

	/** @inheritDoc */
	override protected function startup():void {
		//----------------------------------------------------------------
		// graphcis
		//----------------------------------------------------------------
		bottomBackground=new BitmapImage;
		bottomBackground.source=BottomBGImage;
		addElementAt(bottomBackground, 0);

		leftLine=new Rect;
		leftLine.fill=new SolidColor(0x999999);
		addElementAt(leftLine, 0);

		leftBackground=new Rect;
		leftBackground.fill=new SolidColor(0xe6ecf1);
		addElementAt(leftBackground, 0);
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
		removeAllElements();

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
		resizeBottomGraphics(space.y);

		fileListRefresh.x=space.x + 10;
		fileListRefresh.y=space.y + int(space.height / 2) - int(fileListRefresh.height / 2);

		srcManagerOpener.x=space.x + int(space.width / 2) - int(srcManagerOpener.width / 2);
		srcManagerOpener.y=space.y + int(space.height / 2) - int(srcManagerOpener.height / 2);
	}

	override protected function updateSpaceOfBottomRight(space:Rectangle):void {
		resizeBottomGraphics(space.y);

		docRefresher.x=space.x + space.width - docRefresher.width - 10;
		docRefresher.y=space.y + int(space.height / 2) - int(docRefresher.height / 2);

		docLocationOpener.x=space.x + int(space.width / 2) - int(docLocationOpener.width / 2);
		docLocationOpener.y=space.y + int(space.height / 2) - int(docLocationOpener.height / 2);
	}

	override protected function updateSpaceOfTopLeft(space:Rectangle):void {
		leftBackground.x=space.x;
		leftBackground.y=space.y;
		leftBackground.width=space.width;
		leftBackground.height=space.height;

		leftLine.x=space.x + space.width - 1;
		leftLine.y=space.y;
		leftLine.width=1;
		leftLine.height=space.height;

		fileList.x=space.x;
		fileList.y=space.y;
		fileList.width=space.width;
		fileList.height=space.height;

		fileListScrollbar.x=space.x + space.width - fileListScrollbar.width;
		fileListScrollbar.y=space.y;
		fileListScrollbar.height=space.height;
	}

	override protected function updateSpaceOfTopRight(space:Rectangle):void {
		docViewer.x=space.x;
		docViewer.y=space.y;
		docViewer.width=space.width;
		docViewer.height=space.height;
	}

	override protected function getResizer():IVisualElement {
		var bitmap:BitmapData=new BottomResizerImage().bitmapData;
		var hw:int=(bitmap.width / 2) + 1;
		var hh:int=bitmap.height / 2;

		var mat:Matrix=new Matrix;
		mat.translate(-hw, -hh);

		var sp:SpriteVisualElement=new SpriteVisualElement;
		sp.graphics.beginBitmapFill(bitmap, mat);
		sp.graphics.drawRect(-hw, -hh, bitmap.width, bitmap.height);
		sp.graphics.endFill();
		return sp;
	}

	private function resizeBottomGraphics(y:int):void {
		bottomBackground.y=y;
		bottomBackground.width=stage.stageWidth;
	}
}
}
