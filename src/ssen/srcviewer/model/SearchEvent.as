package ssen.srcviewer.model {
import flash.events.Event;

public class SearchEvent extends Event {
	public static const CHANGED_KEYWORD:String="changedKeyword";

	public function SearchEvent(type:String) {
		super(type, false, false);
	}

	override public function clone():Event {
		return new SearchEvent(type);
	}


}
}
