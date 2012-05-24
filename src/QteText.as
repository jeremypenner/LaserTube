package  {
	/**
	 * ...
	 * @author Jeremy Penner
	 */
	public class QteText extends Qte {
		public var text:String;
		public function QteText(text:String = null, secTrigger:Number=-1, secTimeout:Number=-1, fDirty:Boolean=false) {
			super(secTrigger, secTimeout, fDirty);
			this.text = text;
		}
		
		override protected function shapeToJson():Object {
			return { 'text': text };
		}
		override protected function setShapeFromJson(shape:Object):void {
			text = shape.text;
		}
	}

}