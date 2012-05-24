package  
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author jjp
	 */
	public class Qte
	{
		public var msTrigger:int;
		public var msTimeout:int;
		public var fDirty:Boolean;
		
		public function Qte(secTrigger:Number = -1, secTimeout:Number = -1, fDirty: Boolean = false) 
		{
			if (secTrigger >= 0)
				this.msTrigger = int(secTrigger * 1000);
			else
				this.msTrigger = -1;
				
			if (secTimeout >= 0) {
				this.msTimeout = int(secTimeout * 1000);
				Util.assert(msTimeout > msTrigger);
			} else if (msTrigger >= 0) {
				msTimeout = msTrigger + 1000; // 1 second timeout by default
			} else {
				msTimeout = -1;
			}
			this.fDirty = fDirty;
		}

		public static function compare(qte1:Qte, qte2:Qte):int
		{
			if (qte1.msTrigger == qte2.msTrigger)
				return 0;
			else if (qte1.msTrigger < qte2.msTrigger)
				return -1;
			return 1;
		}
		public function secTrigger():Number
		{
			return msTrigger / 1000.0;
		}
		public function secTimeout():Number 
		{
			return msTimeout / 1000.0;
		}
		protected function shapeToJson():Object {
			return null;
		}
		protected function setShapeFromJson(shape:Object):void {}
		public function ToJson():Object
		{
			return { shape: this.shapeToJson(), ms_trigger: msTrigger, ms_finish: msTimeout };
		}
		public static function FromJson(json:Object):Qte
		{
			var qte:Qte;
			if (json.shape.radius) 
				qte = new QteCircle();
			else if (json.shape.text)
				qte = new QteText();
			else
				return null;
				
			qte.setShapeFromJson(json.shape);
			qte.msTrigger = json.ms_trigger;
			qte.msTimeout = json.ms_finish;
			
			return qte;
		}
	}
}