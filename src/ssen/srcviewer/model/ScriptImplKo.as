package ssen.srcviewer.model {

public class ScriptImplKo implements IScript {

	public function get chooseYourOneDirectoryForAddedToSrcViewFile():String {
		return "추가할 소스코드 디렉토리를 선택해 주세요.";
	}

	public function get selectSrcViewFileForCreate():String {
		return "생성할 .srcview 파일의 위치와 이름을 선택해 주세요.";
	}

	public function get selectSrcViewFileForOpen():String {
		return "사용할 .srcview 파일의 위치를 선택해 주세요.";
	}

	public function get clearRecentlySrcViewFileHistory():String {
		return "모든 .srcview 파일의 사용 기록을 지웁니다.";
	}

	public function get createNewSrcViewFile():String {
		return "새로운 .srcview 파일을 만듭니다.";
	}

	public function get openSrcViewFile():String {
		return "기존 .srcview 파일을 엽니다";
	}



}
}
