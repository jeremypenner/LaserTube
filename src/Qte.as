package  
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author jjp
	 */
	public class Qte
	{
		public var center:Point;
		public var radius:Number;
		public var msTrigger:int;
		public var msTimeout:int;
		public var fDirty:Boolean;
		
		public function Qte(center: Point = null, radius: Number = -1, secTrigger:Number = -1, secTimeout:Number = -1, fDirty: Boolean = false) 
		{
			this.center = center;
			this.radius = radius;
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
		public function moveTo(center: Point): void
		{
			fDirty = true;
			this.center = center;
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
			return secTrigger() + 1.0;
		}
		public function ToJson():Object
		{
			return { shape: {center: [center.x, center.y], radius: radius}, ms_trigger: msTrigger, ms_finish: msTimeout };
		}
		public function FromJson(json:Object):void
		{
			center = new Point(json.shape.center[0], json.shape.center[1]);
			radius = json.shape.radius;
			msTrigger = json.ms_trigger;
			msTimeout = json.ms_finish;
		}
	}
}