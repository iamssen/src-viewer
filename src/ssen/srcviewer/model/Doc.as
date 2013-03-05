package ssen.srcviewer.model {
import de.polygonal.ds.HashMap;
import de.polygonal.ds.Itr;

import flash.system.Capabilities;

import ssen.common.MathUtils;
import ssen.common.StringUtils;
import ssen.srcviewer.model.filetypes.Code;
import ssen.srcviewer.model.filetypes.DocFile;
import ssen.srcviewer.model.filetypes.ProcessingScript;
import ssen.srcviewer.model.filetypes.Wiki;


public class Doc {
	private var _name:String;
	private var _map:HashMap;
	private var _source:String;
	private var _hasWiki:Boolean;
	
	public var namespace:String;
	public var visible:Boolean;
	
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
			
			if (dfile is Wiki) {
				_hasWiki=true;
			}
		}
	}
	
	public function hasWiki():Boolean {
		return _hasWiki;
	}
	
	public function getFiles():Itr {
		return _map.iterator();
	}
	
	public function toHtml():String {
		var files:Itr=getFiles();
		var dfile:DocFile;
		var hash:String;
		var base:String;
		var baseIsWiki:Boolean=false;
		var wikis:String='';
		var codes:String='';
		var examples:String='';
		var theory:String='';
		var api:String;
		var str:String;
		
		while (files.hasNext()) {
			dfile=files.next() as DocFile;
			
			if (dfile is Wiki) {
				if (!baseIsWiki) {
					baseIsWiki=true;
					base=dfile.file.parent.nativePath;
				}
				
				hash=MathUtils.randHex(10);
				
				str='<h1 class="paper-title">' + dfile.name + "." + dfile.extension + '</h1><div class="paper"><xmp type="text/markdown" to="' + hash + '" style="display:none;">\n' + dfile.getSource() + '\n</xmp><div class="markdown" id="' + hash + '"></div></div>';
				
				if (dfile.isExample) {
					theory+=str;
				} else {
					wikis+=str;
				}
			} else if (dfile is Code) {
				if (!baseIsWiki) {
					base=dfile.file.parent.nativePath;
				}
				
				if (dfile.isExample) {
					examples+='<h1 class="paper-title">' + dfile.name + "." + dfile.extension + '</h1><div class="paper"><pre class="prettyprint"><code><xmp>' + fixHtmlSpecialCharacters(dfile.getSource()) + '</xmp></code></pre></div>';
				} else {
					codes+='<h1 class="paper-title">' + dfile.name + "." + dfile.extension + '</h1><div class="paper">';
					
					if (dfile.hasAPI()) {
						try {
							hash=MathUtils.randHex(10);
							api=dfile.getAPI();
							codes+='<xmp type="text/markdown" to="' + hash + '" style="display:none;">\n' + api + '\n</xmp><div class="markdown" id="' + hash + '"></div>';
						} catch (error:Error) {
							trace("Doc.toHtml()", error);
						}
					}
					
					codes+='<pre class="prettyprint"><code><xmp>' + fixHtmlSpecialCharacters(dfile.getSource()) + '</xmp></code></pre></div>';
					
				}
			} else if (dfile is ProcessingScript) {
				str='<h1 class="paper-title">' + dfile.name + "." + dfile.extension + '</h1><div class="paper"><script type="application/processing">' + dfile.getSource() + '</script><canvas></canvas><pre class="prettyprint"><code><xmp>' + fixHtmlSpecialCharacters(dfile.getSource()) + '</xmp></code></pre></div>';
				
				examples+=str;
			}
		}
		
		var source:String='<!DOCTYPE html><html><head><base href="file:///' + base.replace(/\\/g, "/") + '/" /><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><link href="app:/doc.css" rel="stylesheet" /><link href="app:/markdown.css" rel="stylesheet" /><link href="app:/prettify.css" rel="stylesheet" /><script src="app:/prettify.js" type="application/javascript"></script><script src="app:/showdown.js" type="application/javascript"></script><script src="app:/showdown.github.js" type="application/javascript"></script><script src="app:/showdown.prettify.js" type="application/javascript"></script><script src="app:/showdown.table.js" type="application/javascript"></script><script src="app:/processing-1.4.1.min.js" type="application/javascript"></script></head><body>' + wikis + theory + codes + examples + '<script src="app:/doc.js"></script></body></html>';
		
		//		trace("Doc.toHtml()", source);
		
		return source;
	}
	
	private function fixHtmlSpecialCharacters(source:String):String {
		//		source=source.replace(/</g, "&lt;");
		//		source=source.replace(/>/g, "&gt;");
		source=source.replace(/<\/xmp/g, "<／xmp");
		source=source.replace(/\t/g, "    ");
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
