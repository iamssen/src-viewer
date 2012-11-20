package ssen.srcviewer.model {
import ssen.mvc.IDependent;
import ssen.mvc.IEventBus;

public class DocModel implements IDependent {
	[Inject]
	public var eventBus:IEventBus;

	public var currentDoc:Doc;

	private var docs:Vector.<Doc>;

	public function addDoc(doc:Doc):void {
		if (docs === null) {
			docs=new Vector.<Doc>;
		}

		docs.push(doc);
	}

	public function clearDocs():void {
		docs=new Vector.<Doc>;
	}

	public function onDependent():void {
		eventBus.addEventListener(DocEvent.OPEN_DOC, docChanged);
	}

	private function docChanged(event:DocEvent):void {
		currentDoc=event.doc;
		eventBus.dispatchEvent(new DocEvent(DocEvent.CHANGED_DOC, event.doc));
	}
}
}
