package ssen.datakit.file {
import de.polygonal.ds.LinkedQueue;
import de.polygonal.ds.Queue;
import de.polygonal.ds.TreeNode;

import flash.filesystem.File;

import ssen.datakit.tokens.IAsyncToken;

public class FolderToTreeConverter {
	public static function convert(srcList:Vector.<File>, root:TreeNode=null, appendLastNodeWith:Function=null):IAsyncToken {
		return new Reader(srcList, root, appendLastNodeWith);
	}

	//==========================================================================================
	// test
	//==========================================================================================
	/** @private */
	[Test]
	public function test():void {
		var folders:Vector.<File>=new Vector.<File>;
		var file:File;

		file=new File;
		file.nativePath="E:\\Workspace\\Dashboard\\src";
		folders.push(file);

		file=new File;
		file.nativePath="E:\\Workspace\\LyndaDownloader\\src";
		folders.push(file);

		var token:IAsyncToken=new Reader(folders);
		token.result=function(root:TreeNode):void {
			trace("SrcListToTreeNode.test.result()", root);
		};
		token.fault=function(error:Error):void {
			trace("SrcListToTreeNode.test.fault()", error);
		};
	}

	[Test]
	public function queueTest():void {
		var qu:Queue=new LinkedQueue;
		qu.enqueue(1);
		qu.enqueue(2);

		trace("SrcListToTreeNode.queueTest()", qu);

		while (qu.size() > 0) {
			trace("SrcListToTreeNode.queueTest()", qu.dequeue());
		}
	}
}
}
import de.polygonal.ds.LinkedQueue;
import de.polygonal.ds.Queue;
import de.polygonal.ds.TreeNode;

import flash.events.FileListEvent;
import flash.filesystem.File;

import ssen.common.StringUtils;
import ssen.datakit.tokens.IAsyncToken;

class Reader implements IAsyncToken {
	private var queue:Queue;
	private var _root:TreeNode;
	private var _fault:Function;
	private var _result:Function;
	private var currentTicket:Ticket;
	private var _appendLastNodeWith:Function;
	private var _hasAppendLastNodeWith:Boolean;

	public function Reader(list:Vector.<File>, root:TreeNode=null, appendLastNodeWith:Function=null) {
		queue=new LinkedQueue;
		if (root === null) {
			root=new TreeNode;
		}
		_root=root;
		_appendLastNodeWith=appendLastNodeWith;
		_hasAppendLastNodeWith=appendLastNodeWith !== null;

		var f:int=-1;
		var fmax:int=list.length;
		var ticket:Ticket;

		while (++f < fmax) {
			ticket=new Ticket;
			ticket.folder=list[f];
			ticket.readFile=_hasAppendLastNodeWith ? _appendLastNodeWith : addFile;
			ticket.readFolder=addFolder;
			ticket.endRead=readNext;
			ticket.node=root;

			queue.enqueue(ticket);
		}

		readNext();
	}

	//==========================================================================================
	// implements
	//==========================================================================================
	/** @inheritDoc */
	public function close():void {
		if (currentTicket) {
			currentTicket.close();
			currentTicket.dispose();
			currentTicket=null;
		}

		queue=null;
		_root=null;
		_result=null;
		_fault=null;
	}

	/** @inheritDoc */
	public function get fault():Function {
		return _fault;
	}

	/** @inheritDoc */
	public function set fault(value:Function):void {
		_fault=value;
	}

	/** @inheritDoc */
	public function get result():Function {
		return _result;
	}

	/** @inheritDoc */
	public function set result(value:Function):void {
		_result=value;
	}

	/** @inheritDoc */
	public function dispose():void {
		close();
	}

	//==========================================================================================
	// 
	//==========================================================================================
	private function addFile(node:TreeNode, file:File):void {
		node.appendNode(new TreeNode(file));
	}

	private function addFolder(node:TreeNode, folder:File):void {
		var childNode:TreeNode=node.find(folder.name);
		if (childNode === null) {
			childNode=new TreeNode(folder.name);
			node.appendNode(childNode);
		}

		var ticket:Ticket=new Ticket;
		ticket.folder=folder;
		ticket.readFile=_hasAppendLastNodeWith ? _appendLastNodeWith : addFile;
		ticket.readFolder=addFolder;
		ticket.endRead=readNext;
		ticket.node=childNode;
		queue.enqueue(ticket);
	}

	private function readNext():void {
		if (queue.size() > 0) {
			currentTicket=queue.dequeue() as Ticket;
			currentTicket.read();
		} else {
			currentTicket=null;

			if (_result !== null) {
				_result(_root);
			}
		}
	}
}


class Ticket implements IAsyncToken {
	public var node:TreeNode;
	public var folder:File;
	public var readFolder:Function;
	public var readFile:Function;
	public var endRead:Function;
	private var _read:Boolean;

	public function read():void {
		_read=true;
		folder.addEventListener(FileListEvent.DIRECTORY_LISTING, directoryListing);
		folder.getDirectoryListingAsync();
	}

	private function directoryListing(event:FileListEvent):void {
		_read=false;
		folder.removeEventListener(FileListEvent.DIRECTORY_LISTING, directoryListing);

		var files:Array=event.files;
		var file:File;

		var f:int=-1;
		var fmax:int=files.length;
		while (++f < fmax) {
			file=files[f];
			if (file.isDirectory) {
				readFolder(node, file);
			} else if (file.isHidden || file.isPackage || file.isSymbolicLink) {
				continue;
			} else {
				readFile(node, file);
			}
		}

		endRead();
	}

	/** @inheritDoc */
	public function close():void {
		try {
			if (_read && folder) {
				folder.cancel();
			}
		} catch (error:Error) {
			trace("Ticket.close()", error);
		} finally {
			if (folder) {
				folder.removeEventListener(FileListEvent.DIRECTORY_LISTING, directoryListing);
				folder=null;
			}
			node=null;
			readFolder=null;
			readFile=null;
			endRead=null;
			_read=false;
		}
	}

	/** @inheritDoc */
	public function get fault():Function {
		return null;
	}

	/** @inheritDoc */
	public function set fault(value:Function):void {
	}

	/** @inheritDoc */
	public function get result():Function {
		return null;
	}

	/** @inheritDoc */
	public function set result(value:Function):void {
	}

	/** @inheritDoc */
	public function dispose():void {
		close();
	}

	public function toString():String {
		return StringUtils.formatToString('[Ticket folder="{0}"]', folder.nativePath);
	}

}
