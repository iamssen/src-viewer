package ssen.srcviewer.model {

public interface IScript {
	function get createNewSrcViewFile():String;
	function get openSrcViewFile():String;
	function get clearRecentlySrcViewFileHistory():String;

	function get selectSrcViewFileForCreate():String;
	function get selectSrcViewFileForOpen():String;
	function get chooseYourOneDirectoryForAddedToSrcViewFile():String;
}
}
