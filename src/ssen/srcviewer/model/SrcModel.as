package ssen.srcviewer.model {
import de.polygonal.ds.DLL;
import de.polygonal.ds.TreeNode;

import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.FileFilter;
import flash.net.SharedObject;

import ssen.common.IDisposable;
import ssen.common.MathUtils;
import ssen.datakit.file.FileUtils;
import ssen.datakit.file.FolderToTreeConverter;
import ssen.common.IAsyncUnit;
import ssen.srcviewer.model.filetypes.DocFile;

final public class SrcModel implements IDisposable {

	[Inject]
	public var docmodel:DocModel;

	[Inject]
	public var script:IScript;

	private var srcFolderList:Vector.<File>;
	private var srcViewFile:File;
	private var _docmodel:DocModel;

	public function hasSrcViewFile():Boolean {
		return srcViewFile !== null;
	}

	public function dispose():void {
		srcFolderList=null;
		srcViewFile=null;
	}

	//----------------------------------------------------------------
	// history management
	//----------------------------------------------------------------
	public function getHistory(result:Function):void {
		result(getHistoryStore().slice());
	}

	public function removeHistory(path:String):void {
		var history:Array=getHistoryStore();
		var index:int=history.indexOf(path);

		if (index > -1) {
			history.splice(index, 1);
		}
	}

	public function removeAllHistory():void {
		var history:Array=getHistoryStore();
		history.length=0;
	}

	private function addHistory(file:File):void {
		var history:Array=getHistoryStore();
		var path:String=file.nativePath;
		var index:int=history.indexOf(path);

		if (index === -1) {
			history.push(path);
		}
	}

	private function getHistoryStore():Array {
		var so:SharedObject=SharedObject.getLocal("SrcViewer");

		if (so.data["history"] === undefined) {
			so.data["history"]=[];
		}

		var list:Array=so.data["history"];
		var list2:Array=[];
		var path:String;
		var file:File=new File;

		var f:int=-1;
		var fmax:int=list.length;
		while (++f < fmax) {
			path=list[f];
			file.nativePath=path;

			if (file.exists) {
				list2.push(path);
			}
		}

		if (list.length !== list2.length) {
			so.data["history"]=list2;
		}

		return so.data["history"];
	}

	//----------------------------------------------------------------
	// src view file 생성 열기
	//----------------------------------------------------------------
	public function createSrcViewFile(result:Function):void {
		var creator:FileCreator=new FileCreator;
		creator.callback=function(srcfile:File=null):void {
			if (srcfile === null) {
				result(false);
				return;
			}

			var fileName:String=FileUtils.addExtensionToFileName(srcfile.name, "srcview");

			if (fileName !== srcfile.name) {
				srcfile=srcfile.parent.resolvePath(fileName);
			}

			srcViewFile=srcfile;

			exportSrcFolderListToFile();

			srcFolderList=new Vector.<File>;

			addSrcFolder(function(added:Boolean):void {

				result(true);

				addHistory(srcfile);
			});
		};
		creator.create(File.userDirectory, script.selectSrcViewFileForCreate);
	}

	public function openSrcViewFile(result:Function):void {
		var opener:FileOpener=new FileOpener;
		opener.callback=function(srcfile:File=null):void {
			if (srcfile === null) {
				result(false);
				return;
			}

			srcViewFile=srcfile;

			importSrcFolderListFromFile();

			result(true);

			addHistory(srcfile);
		};
		opener.open(File.userDirectory, script.selectSrcViewFileForOpen, SrcViewFileFilter.get());
	}

	public function readSrcViewFile(path:String, result:Function):void {
		var file:File=new File;
		file.nativePath=path;

		if (file.exists && file.extension === "srcview") {
			srcViewFile=file;

			importSrcFolderListFromFile();
			result(true);
		} else {
			result(false);
		}
	}

	//----------------------------------------------------------------
	// src list 추가 삭제 읽기
	//----------------------------------------------------------------
	public function addSrcFolder(result:Function):void {
		var opener:FolderOpener=new FolderOpener;
		opener.callback=function(srcfolder:File=null):void {
			if (srcfolder !== null) {
				var index:int=-1;
				var f:int=srcFolderList.length;
				while (--f >= 0) {
					if (srcFolderList[f].nativePath === srcfolder.nativePath) {
						index=f;
						break;
					}
				}

				if (index > -1) {
					result(false);
					return;
				}

				srcFolderList.push(srcfolder);
				exportSrcFolderListToFile();
				result(true);
			} else {
				result(false);
			}
		};
		opener.open(File.userDirectory, script.chooseYourOneDirectoryForAddedToSrcViewFile);
	}

	public function removeSrcFolder(srcfolder:File, result:Function):void {
		var index:int=-1;
		var f:int=srcFolderList.length;
		while (--f >= 0) {
			if (srcFolderList[f].nativePath === srcfolder.nativePath) {
				index=f;
				break;
			}
		}

		if (index === -1) {
			result(false);
			return;
		}

		srcFolderList.splice(index, 1);
		exportSrcFolderListToFile();
		result(true);
	}

	public function getSrcList():Vector.<File> {
		return srcFolderList.slice();
	}

	//----------------------------------------------------------------
	// tree
	//----------------------------------------------------------------
	public function getSrcTree():IAsyncUnit {
		docmodel.clearDocs();
		return FolderToTreeConverter.convert(srcFolderList, null, appendFileNodeWith);
	}

	private function appendFileNodeWith(node:TreeNode, file:File):void {
		var dfile:DocFile=DocFile.getDocFile(file);

		if (dfile === null) {
			return;
		}

		// group name 결정
		var gname:String=FileUtils.removeExtension(file.name);
		if (gname.search("__Example") > -1) {
			gname=gname.substr(0, gname.length - 9);
		}

		// node 추가
		var gnode:TreeNode=node.find("@" + gname);
		var doc:Doc;

		if (gnode === null) {
			var path:DLL=new DLL;
			var n:TreeNode=node;

			while (!n.isRoot()) {
				path.prepend(n.val);
				n=n.parent;
			}

			path.append(gname);

			doc=new Doc(gname);
			doc.namespace=path.join(".");

			gnode=new TreeNode("@" + gname);
			gnode.appendNode(new TreeNode(doc));
			node.appendNode(gnode);

			docmodel.addDoc(doc);
		} else {
			doc=gnode.getChildAt(0).val as Doc;
		}

		//		trace("SrcList.appendFileNodeWith()", doc, dfile);

		doc.addFile(dfile);
	}

	//==========================================================================================
	// utils
	//==========================================================================================
	private function importSrcFolderListFromFile():void {
		srcFolderList=new Vector.<File>;

		var stream:FileStream=new FileStream;
		stream.open(srcViewFile, FileMode.READ);

		var source:String=stream.readUTFBytes(stream.bytesAvailable);

		stream.close();

		if (source === "") {
			return;
		}

		var data:Object=JSON.parse(source);

		var srcFolderListStrings:Array=data.srclist;
		var srcfolder:File;

		var f:int=-1;
		var fmax:int=srcFolderListStrings.length;
		while (++f < fmax) {
			srcfolder=new File;
			srcfolder.nativePath=srcFolderListStrings[f];
			if (srcfolder.exists && srcfolder.isDirectory) {
				srcFolderList.push(srcfolder);
			}
		}
	}

	private function exportSrcFolderListToFile():void {
		var stream:FileStream=new FileStream;
		stream.open(srcViewFile, FileMode.WRITE);

		if (srcFolderList !== null && srcFolderList.length > 0) {
			var srclist:Vector.<String>=getSrcFolderListStrings();
			var data:Object={srclist: srclist};

			stream.writeUTFBytes(JSON.stringify(data));
		} else {
			stream.writeUTFBytes("");
		}

		stream.close();
	}

	private function getSrcFolderListString():String {
		return getSrcFolderListStrings().join("\n");
	}

	private function getSrcFolderListStrings():Vector.<String> {
		var srcFolderListStrings:Vector.<String>=new Vector.<String>(srcFolderList.length, true);

		var f:int=srcFolderList.length;
		while (--f >= 0) {
			srcFolderListStrings[f]=srcFolderList[f].nativePath;
		}

		return srcFolderListStrings;
	}



	//==========================================================================================
	// test
	//==========================================================================================
	/** @private */
	[Test]
	public function toJson():void {
		var vec:Vector.<String>=new <String>["a", "b", "c"];
		var json:String=JSON.stringify({aaa: 1, bbb: 2, ccc: "222", ddd: vec});
		var obj:Object=JSON.parse(json);

		trace("SrcList.toJson()", json);
		trace("SrcList.toJson()", obj);

	}

	/** @private */
	[Test]
	public function testAddSrc():void {
		addSrcFolder(function(added:Boolean):void {
			trace("SrcList.testAddSrc", added, getSrcList());
		});
	}

	/** @private */
	[Test]
	public function testRemoveSrc():void {
		removeSrcFolder(srcFolderList[MathUtils.rand(0, srcFolderList.length - 1)], function(removed:Boolean):void {
			trace("SrcList.testRemoveSrc", removed, getSrcList());
		});
	}

	/** @private */
	[Test]
	public function testCreateSrcViewFile():void {
		createSrcViewFile(function(created:Boolean):void {
			if (created) {
				trace("SrcList.testCreateSrcViewFile", created, srcViewFile.nativePath, getSrcFolderListString());
			}
		});
	}

	/** @private */
	[Test]
	public function testOpenSrcViewFile():void {
		openSrcViewFile(function(open:Boolean):void {
			if (open) {
				trace("SrcList.testOpenSrcViewFile", open, srcViewFile.nativePath, getSrcFolderListString());
			}
		});
	}

	/** @private */
	[Test]
	public function testReadSrcViewFile():void {
		readSrcViewFile("C:\\Users\\SSen\\Desktop\\test.srcview", function(open:Boolean):void {
			if (open) {
				trace("SrcList.testReadSrcViewFile", open, srcViewFile.nativePath, getSrcFolderListString());
			}
		});
	}

	/** @private */
	[Test]
	public function testReadSrcList():void {
		trace("SrcListModel.testReadSrcList()", getSrcFolderListString());
	}

}
}
import flash.events.Event;
import flash.filesystem.File;
import flash.net.FileFilter;

class SrcViewFileFilter {
	public static function get():FileFilter {
		return new FileFilter("Src View File", "*.srcview;");
	}
}

class FileCreator {
	public var callback:Function;
	private var file:File;

	public function create(defaultLocation:File, title:String):void {
		file=defaultLocation;
		file.addEventListener(Event.CANCEL, cancelHandler);
		file.addEventListener(Event.SELECT, selectHandler);
		file.browseForSave(title);
	}

	private function dispose():void {
		file.removeEventListener(Event.CANCEL, cancelHandler);
		file.removeEventListener(Event.SELECT, selectHandler);
		file=null;
		callback=null;
	}

	private function selectHandler(event:Event):void {
		callback(file);
		dispose();
	}

	private function cancelHandler(event:Event):void {
		callback(null);
		dispose();
	}
}

class FileOpener {
	public var callback:Function;
	private var file:File;

	public function open(defaultLocation:File, title:String, filter:FileFilter):void {
		file=defaultLocation;
		file.addEventListener(Event.CANCEL, cancelHandler);
		file.addEventListener(Event.SELECT, selectHandler);
		file.browseForOpen(title, [filter]);
	}

	private function dispose():void {
		file.removeEventListener(Event.CANCEL, cancelHandler);
		file.removeEventListener(Event.SELECT, selectHandler);
		file=null;
		callback=null;
	}

	private function selectHandler(event:Event):void {
		callback(file);
		dispose();
	}

	private function cancelHandler(event:Event):void {
		callback(null);
		dispose();
	}
}

class FolderOpener {
	public var callback:Function;
	private var folder:File;

	public function open(defaultLocation:File, title:String):void {
		folder=defaultLocation;
		folder.addEventListener(Event.CANCEL, cancelHandler);
		folder.addEventListener(Event.SELECT, selectHandler);
		folder.browseForDirectory(title);
	}

	private function dispose():void {
		folder.removeEventListener(Event.CANCEL, cancelHandler);
		folder.removeEventListener(Event.SELECT, selectHandler);
		folder=null;
		callback=null;
	}

	private function selectHandler(event:Event):void {
		callback(folder);
		dispose();
	}

	private function cancelHandler(event:Event):void {
		callback(null);
		dispose();
	}
}
