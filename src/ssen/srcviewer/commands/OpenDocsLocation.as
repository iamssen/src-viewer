package ssen.srcviewer.commands {
import de.polygonal.ds.HashMap;
import de.polygonal.ds.Itr;

import flash.filesystem.File;

import ssen.mvc.ICommand;
import ssen.mvc.ICommandChain;
import ssen.srcviewer.model.DocModel;
import ssen.srcviewer.model.filetypes.DocFile;

public class OpenDocsLocation implements ICommand {
	[Inject]
	public var docmodel:DocModel;

	public function execute(chain:ICommandChain=null):void {
		if (docmodel === null || docmodel.currentDoc === null) {
			chain.next();
			return;
		}

		var pathmap:HashMap=new HashMap(true);
		var dfiles:Itr=docmodel.currentDoc.getFiles();
		var dfile:DocFile;

		while (dfiles.hasNext()) {
			dfile=dfiles.next() as DocFile;

			if (!pathmap.has(dfile.file.parent.nativePath)) {
				pathmap.set(dfile.file.parent.nativePath, dfile.file.parent);
			}
		}

		var paths:Itr=pathmap.iterator();
		var path:File;

		while (paths.hasNext()) {
			path=paths.next() as File;
			path.openWithDefaultApplication();
		}

		chain.next();
	}

	public function dispose():void {
		docmodel=null;
	}
}
}
