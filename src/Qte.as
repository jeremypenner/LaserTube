package  
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author jjp
	 */
	public class Qte
	{
		public var rgpoint:Array;
		public var secTrigger:Number;
		
		public function Qte(rgpoint: Array = null, secTrigger:Number = -1) 
		{
			this.rgpoint = rgpoint;
			this.secTrigger = secTrigger;
		}
		public static function compare(qte1:Qte, qte2:Qte):int
		{
			if (qte1.secTrigger == qte2.secTrigger)
				return 0;
			else if (qte1.secTrigger < qte2.secTrigger)
				return -1;
			return 1;
		}
		public function ToJson():Object
		{
			var jsonRgpoint:Array = [];
			for each(var point:Point in rgpoint)
				jsonRgpoint.push([point.x, point.y]);
			return { rgpoint: jsonRgpoint, secTrigger: secTrigger };
		}
		public function FromJson(json:Object):void
		{
			rgpoint = []
			for each(var jsonPoint:Array in json.rgpoint)
				rgpoint.push(new Point(jsonPoint[0], jsonPoint[1]));
			secTrigger = json.secTrigger;
		}
	}
}