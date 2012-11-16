package ssen.srcviewer.model {
import de.polygonal.ds.DLL;
import de.polygonal.ds.HashMap;
import de.polygonal.ds.Itr;

import flash.filesystem.File;
import flash.system.Capabilities;

import ssen.common.MathUtils;
import ssen.common.StringUtils;
import ssen.srcviewer.model.filetypes.Code;
import ssen.srcviewer.model.filetypes.DocFile;
import ssen.srcviewer.model.filetypes.Wiki;


public class Doc {
	private var _name:String;
	private var _map:HashMap;
	private var _source:String;
	
	public var namespace:String;

	public function Doc(name:String) {
		_name=name;
		_map=new HashMap;
	}

	public function get name():String {
		return _name;
	}

	internal function addFile(dfile:DocFile):void {
		if (!_map.has(dfile.file.name)) {
			_map.set(dfile.file.name, dfile);
		}
	}

	public function getFiles():Itr {
		return _map.iterator();
	}

	public function toHtml():String {
		var files:Itr=getFiles();
		var file:DocFile;
		var hash:String;
		var base:String;
		var baseIsWiki:Boolean=false;
		var wikis:String='';
		var codes:String='';
		var examples:String='';

		while (files.hasNext()) {
			file=files.next() as DocFile;

			if (file is Wiki) {
				if (!baseIsWiki) {
					baseIsWiki=true;
					base=file.file.parent.nativePath;
				}

				hash=MathUtils.randHex(10);
				wikis+='<h1 class="paper-title">'+file.name + "." + file.extension+'</h1><div class="paper"><xmp type="text/markdown" to="'+hash+'" style="display:none;">\n'+file.getSource()+'\n</xmp><div class="markdown" id="'+hash+'"></div></div>';
			} else {
				if (!baseIsWiki) {
					base=file.file.parent.nativePath;
				}

				if (file is Code) {
					codes+='<h1 class="paper-title">'+file.name + "." + file.extension+'</h1><div class="paper"><pre><code class="language-'+file.highlighterType+'"><xmp>'+file.getSource()+'</xmp></code></pre></div>';
				} else {
					examples+='<h1 class="paper-title">'+file.name + "." + file.extension+'</h1><div class="paper"><pre><code class="language-'+file.highlighterType+'"><xmp>'+file.getSource()+'</xmp></code></pre></div>';
				}


			}
		}

		var source:String='<!DOCTYPE html><html><head><base href="file:///' + base.replace(/\\/g, "/") + '/" /><link href="app:/doc.css" rel="stylesheet" /><script src="app:/showdown.js" type="application/javascript"></script></head><body>' + wikis + codes + examples + '<script src="app:/prism.js" data-default-language="none"></script><script src="app:/doc.js"></script></body></html>';

//		trace("Doc.toHtml()", source);

		return source;
	}

	public function toString():String {
		var files:String;

		if (Capabilities.isDebugger) {
			var itr:Itr=_map.iterator();
			var names:Vector.<String>=new Vector.<String>(_map.size(), true);
			var dfile:DocFile;
			var f:int=0;

			while (itr.hasNext()) {
				dfile=itr.next() as DocFile;
				names[f]=dfile.toString();
				f++;
			}

			files=names.join(", ");
		} else {
			files="";
		}

		return StringUtils.formatToString('[Doc name="{0}" files="{1}"]', _name, files);
	}
}
}
