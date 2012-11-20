package ssen.srcviewer.model {
import ssen.common.StringUtils;
import ssen.mvc.IEventBus;

public class SearchModel {
	[Inject]
	public var eventBus:IEventBus;

	private var _keyword:String;

	public function get keyword():String {
		return _keyword;
	}

	public function set keyword(value:String):void {
		if (value !== null) {
			_keyword=StringUtils.clearBlank(value.toLowerCase());
		}

		eventBus.dispatchEvent(new SearchEvent(SearchEvent.CHANGED_KEYWORD));
	}
}
}
