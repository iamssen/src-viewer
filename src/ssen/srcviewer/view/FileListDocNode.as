package ssen.srcviewer.view {
import de.polygonal.ds.TreeNode;

import flash.events.MouseEvent;

import ssen.srcviewer.model.Doc;
import ssen.srcviewer.model.DocEvent;

public class FileListDocNode extends FileListNode {
	private var _doc:Doc;
	
	override protected function saveInfo(node:TreeNode):void {
		_doc=node.val as Doc;
	}
	
	override protected function getLabelText():String {
		return _doc.name;
	}
	
	override protected function addInteraction():void {
		addEventListener(MouseEvent.CLICK, clickHandler);
	}
	
	private function clickHandler(event:MouseEvent):void {
		var evt:DocEvent=new DocEvent(DocEvent.OPEN_DOC);
		evt.doc=_doc;
		eventBus.dispatchEvent(evt);
	}
	
	override public function get isDoc():Boolean {
		return true;
	}
	
	override public function get hasWiki():Boolean {
		return _doc.hasWiki();
	}
	
	override public function dispose():void {
		super.dispose();
		
		removeEventListener(MouseEvent.CLICK, clickHandler);
		eventBus=null;
		_doc=null;
	}
}
}
