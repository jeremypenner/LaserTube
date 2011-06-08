package  
{
	import com.adobe.serialization.json.JSON;
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author jjp
	 */
	public class Util
	{
		public static function binarySearch(rgo:Array, o:*, dgCompare:Function):int
		{
			var imin:int = 0;
			var imax:int = rgo.length - 1;
			while (imax >= imin)
			{
				var imid:int = Math.floor((imax + imin) / 2);
				var kcompare:int = dgCompare(rgo[imid], o);
				if (kcompare == 0)
					return imid;
				else if (kcompare < 0)
					imin = imid + 1;
				else
					imax = imid - 1;
			}
			return -imin;
		}
		public static function FInTimespan(sec:Number, secPrev:Number, secNow:Number):Boolean
		{
			return (sec <= secNow) && (sec > secPrev);
		}
		public static function alert(...rgo:*):void
		{
			ExternalInterface.call("alert", JSON.encode(rgo));
		}
	}

}