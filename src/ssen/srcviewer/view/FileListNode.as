package ssen.srcviewer.view {
import de.polygonal.ds.TreeNode;

import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.text.engine.TextLine;

import flashx.textLayout.compose.TextLineRecycler;
import flashx.textLayout.factory.StringTextLineFactory;
import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.TextLayoutFormat;
import flashx.textLayout.formats.VerticalAlign;

import spark.core.SpriteVisualElement;

import ssen.common.IDisposable;
import ssen.mvc.IEventBus;

public class FileListNode extends SpriteVisualElement implements IDisposable {
	[Embed(source="assets/left.doc.png")]
	public static var DocImage:Class;

	[Embed(source="assets/left.folder.png")]
	public static var FolderImage:Class;

	private static var docImage:BitmapData;
	private static var folderImage:BitmapData;

	private static function getDocImage():BitmapData {
		if (docImage === null) {
			docImage=new DocImage().bitmapData;
		}

		return docImage;
	}

	private static function getFolderImage():BitmapData {
		if (folderImage === null) {
			folderImage=new FolderImage().bitmapData;
		}

		return folderImage;
	}

	private static var mat:Matrix=new Matrix;

	private static const WIDTH:int=1000;
	private static const HEIGHT:int=25;
	private static var factory:StringTextLineFactory;

	public var poolid:int;
	public var eventBus:IEventBus;

	private var textLine:TextLine;
	private var _width:int;
	private var _height:int;
	private static var iconMatrix:Matrix;

	public static function getFactory():StringTextLineFactory {
		if (factory) {
			return factory;
		}

		var format:TextLayoutFormat=new TextLayoutFormat;
		format.verticalAlign=VerticalAlign.MIDDLE;
		format.textAlign=TextAlign.LEFT;

		factory=new StringTextLineFactory;
		factory.compositionBounds=new Rectangle(0, 0, WIDTH, HEIGHT);
		factory.textFlowFormat=format;

		return factory;
	}

	public function setNode(node:TreeNode):void {
		saveInfo(node);

		var factory:StringTextLineFactory=getFactory();
		factory.compositionBounds.x=((node.depth() - 1) * 12) + 24;
		factory.compositionBounds.width=WIDTH - factory.compositionBounds.x;
		factory.text=getLabelText();
		factory.createTextLines(createdTextLines);

		_width=textLine.x + textLine.width;
		_height=HEIGHT;

		graphics.beginFill(0xffffff, 0);
		graphics.drawRect(0, 0, _width, _height);
		graphics.endFill();

		var icon:BitmapData=isDoc ? getDocImage() : getFolderImage();
		mat.identity();
		mat.translate(textLine.x - 17, 6);

		graphics.beginBitmapFill(icon, mat);
		graphics.drawRect(mat.tx, mat.ty, icon.width, icon.height);
		graphics.endFill();

		addInteraction();
	}

	public function dispose():void {
		graphics.clear();

		if (textLine) {
			removeChild(textLine);
			TextLineRecycler.addLineForReuse(textLine);
			textLine=null;
		}
	}

	protected function saveInfo(node:TreeNode):void {

	}

	protected function addInteraction():void {
		// TODO addInteraction

	}

	private function createdTextLines(line:TextLine):void {
		addChild(line);
		textLine=line;
	}

	protected function getLabelText():String {
		throw new Error("not implemented");
	}

	override public function get height():Number {
		return _height;
	}

	override public function get width():Number {
		return _width;
	}

	public function get isDoc():Boolean {
		throw new Error("not implemented");
	}
}
}
