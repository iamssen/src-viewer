# `.srcview` file type

# 필요한 기능들

- Chooser
	- 새로운 파일 만들기
	- 기존 파일 열기
	- 파일 히스토리
		- 열기
		- 히스토리 지우기
		
- Reader
	- SrcManager
		- 목록 : SrcModel.getSrcList()
		- 추가 : ViewEvent.ADD_SRC --> SrcModel.addSrc()
		- 제거 : ViewEvent.REMOVE_SRC --> SrcModel.removeSrc()
	- 좌측 파일 목록
		- 디자인 형태는 꺽은선 포함 표현으로 하고, 각 단위를 무작위의 파스텔 컬러의 모자이크로 처리...
		- 검색에 걸린 단어 아이템은 검은색으로 강하게 표현
		- src 관리자 열기 : ViewEvent.REGISTER_SRC_MANAGER --> SrcViewerWindowMediator.addEventListener()
		- 목록 새로 고침 : ViewEvent.REFRESH_FILE_LIST --> FileList.addEventListener()
		- 검색  : FileListSearch extends SkinnableComponent
		- 목록 : SrcModel.getFileList()...?
	- 우측 본문
		- 본문 새로 고침
		- 본문 위치 열기 (디렉토리)
		- 본문
