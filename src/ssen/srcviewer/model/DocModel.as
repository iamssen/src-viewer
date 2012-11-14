package ssen.srcviewer.model {
import ssen.mvc.IDependent;
import ssen.mvc.IEventBus;

public class DocModel implements IDependent {
	[Inject]
	public var eventBus:IEventBus;

	public var currentDoc:Doc;

	public function onDependent():void {
		eventBus.addEventListener(DocEvent.OPEN_DOC, docChanged);
	}

	private function docChanged(event:DocEvent):void {
		currentDoc=event.doc;
		eventBus.dispatchEvent(new DocEvent(DocEvent.CHANGED_DOC, event.doc));
	}
}
}
