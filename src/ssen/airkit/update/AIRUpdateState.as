package ssen.airkit.update {


final public class AIRUpdateState {
	/** update 가 있을때, update() 에 대한 호출에 대기함 */
	public static const AVAILABLE:AIRUpdateState=new AIRUpdateState("available");

	/** update 이후 처음 실행됨, 업데이트에 대한 구성 변경이 필요함 */
	public static const UPDATED:AIRUpdateState=new AIRUpdateState("updated");

	/** update 가 없음 */
	public static const NONE:AIRUpdateState=new AIRUpdateState("none");

	/** update 진행 중에 에러가 발생했음 */
	public static const ERROR:AIRUpdateState=new AIRUpdateState("error");

	private var _annotation:String;

	public function AIRUpdateState(annotaion:String="") {
		_annotation=annotaion;
	}

	public function get annotation():String {
		return _annotation;
	}
}
}
