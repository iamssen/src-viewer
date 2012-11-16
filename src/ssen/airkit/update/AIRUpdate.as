package ssen.airkit.update {
import air.update.ApplicationUpdater;
import air.update.events.DownloadErrorEvent;
import air.update.events.StatusFileUpdateErrorEvent;
import air.update.events.StatusFileUpdateEvent;
import air.update.events.StatusUpdateErrorEvent;
import air.update.events.StatusUpdateEvent;
import air.update.events.UpdateEvent;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.ProgressEvent;
import flash.net.NetworkInfo;
import flash.net.NetworkInterface;

import ssen.common.IDisposable;

/** 업데이트 체크가 끝나면 보냄 */
[Event(name="init", type="flash.events.Event")]

/** 간단한 구성을 가진 updater, update 를 확인해서 알려준 다음, update() 호출에 의해서 download 와 install 이 진행되게 된다. */
final public class AIRUpdate extends EventDispatcher implements IDisposable {
	/* *********************************************************************
	 * settings
	 ********************************************************************* */
	/** update xml 의 주소 */
	public var updateURL:String;

	/* *********************************************************************
	 * info
	 ********************************************************************* */
	private var _updater:ApplicationUpdater;

	private var _state:AIRUpdateState;

	private var _error:Error;

	/**
	 * construct
	 * @param updateURL update xml 주소
	 */
	public function AIRUpdate(updateURL:String=null):void {
		this.updateURL=updateURL;
	}

	/** @private */
	public function dispose():void {
		if (_updater !== null) {
			_updater.removeEventListener(ErrorEvent.ERROR, errorHandler);
			_updater=null;
		}
	}

	/** update 상태 */
	public function get state():AIRUpdateState {
		return _state;
	}

	/** update 에러 */
	public function get error():Error {
		return _error;
	}

	/* *********************************************************************
	 * default flow
	 ********************************************************************* */
	/** update check 를 실행함 */
	public function check():void {
		if (updateURL == null) {
			throw AIRUpdateError.URL_IS_NULL;
		}

		var nis:Vector.<NetworkInterface>=NetworkInfo.networkInfo.findInterfaces();

		var f:int=-1;
		var max:int=nis.length;
		var aliveInternet:Boolean=false;

		while (++f < max) {
			if (nis[f].active) {
				aliveInternet=true;
				break;
			}
		}

		if (aliveInternet) {
			_updater=new ApplicationUpdater;
			_updater.addEventListener(UpdateEvent.INITIALIZED, initializeHandler);
			_updater.addEventListener(ErrorEvent.ERROR, errorHandler);
			_updater.updateURL=updateURL;
			_updater.initialize();
		} else {
			_state=AIRUpdateState.ERROR;
			_error=AIRUpdateError.NETWORK_DISCONNECT;
			dispatchInit();
		}

	}

	// 예측하지 못하는 에러들에 대한 처리 
	private function errorHandler(event:ErrorEvent):void {
		_state=AIRUpdateState.ERROR;
		_error=new Error(event.text, event.errorID);
		dispatchInit();
	}

	private function dispatchInit():void {
		dispatchEvent(new Event(Event.INIT));
	}

	/* *********************************************************************
	 * after initialize()
	 ********************************************************************* */
	// 초기화가 되었을때 
	private function initializeHandler(event:UpdateEvent):void {
		_updater.removeEventListener(UpdateEvent.INITIALIZED, initializeHandler);
		addCheckEvent();
		_updater.checkNow();
	}

	/* *********************************************************************
	 * after checkNow()
	 ********************************************************************* */
	private function addCheckEvent():void {
		_updater.addEventListener(StatusUpdateErrorEvent.UPDATE_ERROR, updateError);
		_updater.addEventListener(UpdateEvent.CHECK_FOR_UPDATE, checkForUpdate);
		_updater.addEventListener(StatusUpdateEvent.UPDATE_STATUS, updateStatus);
	}

	private function removeCheckEvent():void {
		_updater.removeEventListener(StatusUpdateErrorEvent.UPDATE_ERROR, updateError);
		_updater.removeEventListener(UpdateEvent.CHECK_FOR_UPDATE, checkForUpdate);
		_updater.removeEventListener(StatusUpdateEvent.UPDATE_STATUS, updateStatus);
	}

	// 업데이트 체크가 시작되기 이전 
	private function checkForUpdate(event:UpdateEvent):void {
		//
	}

	// 업데이트 xml 을 찾을 수 없을때 
	private function updateError(event:StatusUpdateErrorEvent):void {
		removeCheckEvent();
		_state=AIRUpdateState.ERROR;
		_error=AIRUpdateError.INVALID_UPDATE_URL;
		dispatchInit();
	}

	// 업데이트 xml 을 분석한 상태 
	private function updateStatus(event:StatusUpdateEvent):void {
		removeCheckEvent();
		if (event.available) {
			_state=AIRUpdateState.AVAILABLE;
		} else {
			if (_updater.isFirstRun) {
				_state=AIRUpdateState.UPDATED;
			} else {
				_state=AIRUpdateState.NONE;
			}
			dispose();
		}

		dispatchInit();

		event.preventDefault();
	}

	/* *********************************************************************
	 * update handling
	 ********************************************************************* */
	/** state 가 AVAILABLE 일때만 작동 */
	public function update():void {
		if (_state == AIRUpdateState.AVAILABLE) {
			addDownloadEvent();
			_updater.downloadUpdate();
		}
	}

	/* *********************************************************************
	 * after download click
	 ********************************************************************* */
	private function addDownloadEvent():void {
		_updater.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		_updater.addEventListener(UpdateEvent.DOWNLOAD_COMPLETE, downloadComplete);
		_updater.addEventListener(UpdateEvent.DOWNLOAD_START, downloadStart);
		_updater.addEventListener(UpdateEvent.BEFORE_INSTALL, beforeInstall);
	}

	private function removeDownloadEvent():void {
		_updater.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
		_updater.removeEventListener(UpdateEvent.DOWNLOAD_COMPLETE, downloadComplete);
		_updater.removeEventListener(UpdateEvent.DOWNLOAD_START, downloadStart);
		_updater.removeEventListener(UpdateEvent.BEFORE_INSTALL, beforeInstall);
	}

	// air 파일의 다운로드가 시작되기 이전 
	private function downloadStart(event:UpdateEvent):void {
		//
	}

	// air 파일 다운로드 프로그레스 
	private function progressHandler(event:ProgressEvent):void {
		//
	}

	// air 파일 다운로드 중 에러  
	private function downloadError(event:DownloadErrorEvent):void {
		// case 1 : 파일을 찾을 수 없을때 (잘못된 주소)
		// case 2 : 버전이 맞지 않음 
		removeDownloadEvent();
		//
	}

	// air 파일 다운로드 완료
	private function downloadComplete(event:UpdateEvent):void {
		//
	}

	/* *********************************************************************
	 * after install
	 ********************************************************************* */
	private function addInstallEvent():void {
		_updater.addEventListener(StatusFileUpdateErrorEvent.FILE_UPDATE_ERROR, fileUpdateError);
		_updater.addEventListener(StatusFileUpdateEvent.FILE_UPDATE_STATUS, fileUpdateStatus);
	}

	private function removeInstallEvent():void {
		_updater.removeEventListener(StatusFileUpdateErrorEvent.FILE_UPDATE_ERROR, fileUpdateError);
		_updater.removeEventListener(StatusFileUpdateEvent.FILE_UPDATE_STATUS, fileUpdateStatus);
	}

	// 설치 이전 
	private function beforeInstall(event:UpdateEvent):void {
		//
		removeDownloadEvent();
	}

	// air 파일 설치 중 발생하는 에러 
	private function fileUpdateError(event:StatusFileUpdateErrorEvent):void {
		//
		removeInstallEvent();
	}

	// air 파일에 대한 검사가 성공적으로 이루어지면 발생됨
	private function fileUpdateStatus(event:StatusFileUpdateEvent):void {
		//
	}
}
}
