package ssen.srcviewer.view.pool {
import de.polygonal.ds.pooling.ObjectPool;

import ssen.srcviewer.view.FileListDocNode;
import ssen.srcviewer.view.FileListFolderNode;
import ssen.srcviewer.view.FileListNode;

public class FileListNodePool {
	private static var _instance:FileListNodePool;

	private var folderPool:ObjectPool;
	private var docPool:ObjectPool;

	public static function getInstance():FileListNodePool {
		if (_instance == null) {
			_instance=new FileListNodePool();
		}
		return _instance;
	}

	public function getNode(wantDoc:Boolean):FileListNode {
		return wantDoc ? getDocNode() : getFolderNode();
	}

	private function getFolderNode():FileListFolderNode {
		if (folderPool === null) {
			folderPool=new ObjectPool(1000);
			folderPool.allocate(true, FileListFolderNode);
		}

		try {
			var pid:int=folderPool.next();
			var node:FileListFolderNode=folderPool.get(pid) as FileListFolderNode;
			node.poolid=pid;
			return node;
		} catch (error:Error) {
			return null;
		}

		return null;
	}

	private function getDocNode():FileListDocNode {
		if (docPool === null) {
			docPool=new ObjectPool(1000);
			docPool.allocate(true, FileListDocNode);
		}

		try {
			var pid:int=docPool.next();
			var node:FileListDocNode=docPool.get(pid) as FileListDocNode;
			node.poolid=pid;
			return node;
		} catch (error:Error) {
			return null;
		}

		return null;
	}

	public function putNode(node:FileListNode):void {
		var pool:ObjectPool=(node.isDoc) ? docPool : folderPool;
		node.dispose();
		pool.put(node.poolid);
	}

	public function putNodes(nodes:Vector.<FileListNode>):void {
		if (nodes === null) {
			return;
		}
		
		var f:int=nodes.length;
		while (--f >= 0) {
			putNode(nodes[f]);
		}
	}
}
}
