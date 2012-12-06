package ssen.srcviewer.view.text {
import flash.text.engine.FontLookup;

import ssen.displaykit.text.IFont;

public class Fonts implements IFont {
	public static const YGO530:Fonts=new Fonts("ygo530", FontLookup.EMBEDDED_CFF);

	private static var pids:int=0;
	private var pid:int;
	private var _fontFamily:String;
	private var _fontLookup:String;

	public function Fonts(fontFamily:String, fontLookup:String) {
		_fontFamily=fontFamily;
		_fontLookup=fontLookup;
		pid=pids;
		pids++;
	}

	public function get fontFamily():String {
		return _fontFamily;
	}

	public function get fontLookup():String {
		return _fontLookup;
	}

	public function equal(font:IFont):Boolean {
		return font is Fonts && Fonts(font).pid === pid;
	}
}
}
