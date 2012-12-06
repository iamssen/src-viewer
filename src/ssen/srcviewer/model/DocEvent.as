package ssen.srcviewer.model {
import ssen.mvc.Evt;

public class DocEvent extends Evt {
	public static const OPEN_DOC:String="openDoc";
	public static const CHANGED_DOC:String="changedDoc";
	
	public var doc:Doc;
	
	public function DocEvent(type:String, doc:Doc=null) {
		super(type);
		this.doc=doc;
	}
}
}
