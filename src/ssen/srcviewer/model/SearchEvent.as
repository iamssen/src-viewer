package ssen.srcviewer.model {
import ssen.mvc.Evt;

public class SearchEvent extends Evt {
	public static const CHANGED_KEYWORD:String="changedKeyword";
	
	public function SearchEvent(type:String) {
		super(type);
	}
}
}
