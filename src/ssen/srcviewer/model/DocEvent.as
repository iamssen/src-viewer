package ssen.srcviewer.model {
import flash.events.Event;

public class DocEvent extends Event {
	public static const OPEN_DOC:String="openDoc";
	public static const CHANGED_DOC:String="changedDoc";

	public var doc:Doc;

	public function DocEvent(type:String, doc:Doc=null) {
		super(type, false, false);
		this.doc=doc;
	}

	override public function clone():Event {
		var evt:DocEvent=new DocEvent(type, doc);
		return evt;
	}



}
}
