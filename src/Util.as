package  
{
	import com.adobe.serialization.json.JSON;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.text.TextFormat;
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
		public static function assert(cond:Boolean, msg:String = "Assertion failed"): void 
		{
			if (!cond) {
				throw new Error(msg);
			}
		}
		public static function BitmapFromSprite(sprite: DisplayObject):Bitmap
		{
			var bitmapData:BitmapData = new BitmapData(sprite.width, sprite.height);
			bitmapData.draw(sprite);
			return new Bitmap(bitmapData);
		}
		public static function addTextFieldFullScreen(parent: DisplayObjectContainer): TextField {
			var text:TextField = new TextField();
			text.wordWrap = true;
			text.background = true;
			text.width = parent.stage.stageWidth;
			text.height = parent.stage.stageHeight;
			parent.addChild(text);
			return text;
		}
		public static function setText(text:TextField, html:String, size:int, bgcolor:int, fgcolor:int):void {
			text.htmlText = "<p align='center'>" + html + "</p>";
			text.backgroundColor = bgcolor;
			text.setTextFormat(new TextFormat(null, size, fgcolor));
		}
	}
}