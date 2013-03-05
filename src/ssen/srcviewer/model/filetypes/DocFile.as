package ssen.srcviewer.model.filetypes {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import ssen.common.StringUtils;
import ssen.devkit.DevUtils;

public class DocFile {
	private static var wikiwikiExtensions:Vector.<String>=new <String>["md", "markdown"];
	private static var codeExtensions:Vector.<String>=new <String>["as", "mxml", "css", "js", "json", "xml", "htm", "html", "xhtml", "py", "rb", "java", "php"];
	private static var processingExtension:String="pde";
	
	public static function getDocFile(file:File):DocFile {
		var dfile:DocFile;
		var filename:String=file.name;
		var extension:String=file.extension;
		
		if (processingExtension === extension) {
			dfile=new ProcessingScript;
		} else if (wikiwikiExtensions.indexOf(extension) > -1) {
			dfile=new Wiki;
		} else if (codeExtensions.indexOf(extension) > -1) {
			dfile=new Code;
		}
		
		if (dfile !== null) {
			dfile.name=filename.substr(0, filename.length - extension.length - 1);
			dfile.extension=extension;
			dfile.file=file;
			dfile.highlighterType=getPrismjsType(extension);
			dfile.isExample=filename.indexOf("__") > -1;
			
			return dfile;
		}
		
		return null;
	}
	
	public var file:File;
	public var name:String;
	public var extension:String;
	public var highlighterType:String;
	public var isExample:Boolean;
	
	public function getSource():String {
		var stream:FileStream=new FileStream;
		stream.open(file, FileMode.READ);
		return stream.readUTFBytes(stream.bytesAvailable).replace(/\r\n/g, "\n");
	}
	
	public function hasAPI():Boolean {
		return false;
	}
	
	public function getAPI():String {
		return null;
	}
	
	private static function getPrismjsType(extension:String):String {
		switch (extension) {
			case "as":
			case "js":
			case "json":
				return "javascript";
				break;
			case "mxml":
			case "html":
			case "htm":
			case "xml":
			case "xhtml":
				return "markup";
				break;
			case "css":
				return "css";
				break;
			case "java":
				return "java";
				break;
			default:
				return "clike";
				break;
		}
	}
	
	public function toString():String {
		return StringUtils.formatToString('[{0} file="{1}"]', DevUtils.getObjectClassName(this), file.name);
	}
}
}
