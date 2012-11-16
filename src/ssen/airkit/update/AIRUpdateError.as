package ssen.airkit.update {

public class AIRUpdateError extends Error {
	public static const INVALID_UPDATE_URL:AIRUpdateError=new AIRUpdateError("update url 이 정확하지 않습니다");

	public static const NETWORK_DISCONNECT:AIRUpdateError=new AIRUpdateError("network 가 연결되어 있지 않습니다.");

	public static const URL_IS_NULL:AIRUpdateError=new AIRUpdateError("update url 을 입력하지 않았음!");

	public function AIRUpdateError(message:String="") {
		super(message);
	}
}
}
