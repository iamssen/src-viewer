package ssen.srcviewer.view {
import de.polygonal.ds.TreeNode;

public class FileListFolderNode extends FileListNode {
	private var _name:String;


	override protected function getLabelText():String {
		return "/" + _name;
	}

	override protected function saveInfo(node:TreeNode):void {
		_name=node.val.toString();
	}

	override public function get isDoc():Boolean {
		return false;
	}

	override public function dispose():void {
		super.dispose();
		_name=null;
	}
}
}
