package ssen.uikit.components {
import flash.events.Event;
import flash.html.HTMLHost;
import flash.html.HTMLLoader;
import flash.net.URLRequest;

import mx.events.PropertyChangeEvent;
import mx.events.ResizeEvent;

import spark.core.IViewport;
import spark.core.NavigationUnit;
import spark.core.SpriteVisualElement;

public class HtmlView extends SpriteVisualElement implements IViewport {
	private var _width:int=0;
	private var _height:int=0;
	private var _html:HTMLLoader;
	private var _title:String;
	private var _ment:String;
	private var _documentRoot:String;
	private var _init:Boolean;

	public function HtmlView() {
		_html=new HTMLLoader();
		_html.navigateInSystemBrowser=true;

		_html.placeLoadStringContentInApplicationSandbox=true;

		_html.scrollV=0;
		_html.scrollH=0;
		_html.addEventListener(Event.SCROLL, scroll);
		_html.addEventListener(Event.HTML_BOUNDS_CHANGE, renderChange);

		addChild(_html);
	}

	private function renderChange(event:Event):void {
		dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, null, "contentWidth"));
		dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, null, "contentHeight"));
	}

	private function scroll(event:Event):void {
		dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, null, "horizontalScrollPosition"));
		dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, null, "verticalScrollPosition"));
	}

	//----------------------------------------------------------------
	// 
	//----------------------------------------------------------------
	public function loadURL(url:String):void {
		_html.load(new URLRequest(url));
	}

	public function loadString(html:String):void {
		_html.loadString(html);
	}


	/* *********************************************************************
	 * js api
	 ********************************************************************* */
	//	public function setDocument(title:String, ment:String, documentRoot:String):void {
	//		_title=title;
	//		_ment=ment;
	//		_documentRoot=documentRoot + "/";
	//		if (_init)
	//			setDocumentJS();
	//	}
	//
	//	private function setDocumentJS():void {
	//		if (_html.window.setDocument) {
	//			_html.window.setDocument(_title, _ment, _documentRoot);
	//			var anchors:Object=_html.window.document.getElementsByTagName("a");
	//			var f:int=anchors.length;
	//			var url:String;
	//			var reg:RegExp=/document\.html#/;
	//			while (--f >= 0) {
	//				url=anchors[f].toString();
	//				if (anchors[f]["target"] == "_blank" || !reg.test(url)) {
	//					anchors[f].onclick=openLink;
	//				}
	//			}
	//		}
	//	}
	//
	//	private function openLink(event:Object):void {
	//		var anchor:Object=event.currentTarget;
	//		var href:String=anchor["href"];
	//		var target:String=anchor["target"];
	//		trace(href);
	//		if (/file:/.test(href)) {
	//			var file:File=new File;
	//			file.url=href;
	//			if (file.hasOwnProperty("openWithDefaultApplication") && file.exists) {
	//				file.openWithDefaultApplication();
	//			} else {
	//				navigateToURL(new URLRequest(file.nativePath), "_blank");
	//			}
	//		} else {
	//			navigateToURL(new URLRequest(href), target);
	//		}
	//	}

	//----------------------------------------------------------------
	// implements IViewport
	//----------------------------------------------------------------
	override public function get width():Number {
		return _width;
	}

	override public function set width(width:Number):void {
		_width=width;
		_html.width=width;
		dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
	}

	override public function get height():Number {
		return _height;
	}

	override public function set height(height:Number):void {
		_height=height;
		_html.height=height;
		dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
	}

	public function get clipAndEnableScrolling():Boolean {
		return true;
	}

	public function set clipAndEnableScrolling(value:Boolean):void {
		// ignore
	}

	public function get contentHeight():Number {
		return _html.contentHeight;
	}

	public function get contentWidth():Number {
		return _html.contentWidth;
	}

	public function getHorizontalScrollPositionDelta(navigationUnit:uint):Number {
		return NavigationUnit.RIGHT;
	}

	public function getVerticalScrollPositionDelta(navigationUnit:uint):Number {
		return NavigationUnit.DOWN;
	}

	public function get horizontalScrollPosition():Number {
		return _html.scrollH;
	}

	public function set horizontalScrollPosition(value:Number):void {
		_html.scrollH=value;
		dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, null, "horizontalScrollPosition"));
	}

	public function get verticalScrollPosition():Number {
		return _html.scrollV;
	}

	public function set verticalScrollPosition(value:Number):void {
		_html.scrollV=value;
		dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, null, "verticalScrollPosition"));
	}
}
}
