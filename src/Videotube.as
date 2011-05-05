package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author jjp
	 */
	public class Videotube extends Sprite
	{
		public static const READY:String = "videotube-ready";
		
		public function fready():Boolean			{ throw "not implemented"; }
		public function play():void 				{ throw "not implemented"; }
		public function pause():void				{ throw "not implemented"; }
		public function resume():void				{ throw "not implemented"; }
		public function time():Number				{ throw "not implemented"; }
		public function seek(sec:Number):void		{ throw "not implemented"; }
		
		private var secPrev:Number;
		private var iqte:int;
		protected var gamedisc:Gamedisc;
		public function Videotube(gamedisc: Gamedisc)
		{
			this.gamedisc = gamedisc;
			secPrev = 0;
			iqte = 0;
		}
		protected function tick(e: Event):void
		{
			var secNow:Number = time();
			if (secNow > secPrev && secPrev >= 0)
			{
				while(iqte < gamedisc.rgqte.length)
				{
					var qte:Qte = gamedisc.rgqte[iqte];
					if (qte.secTrigger > secNow)
						break;
					if (qte.secTrigger > secPrev)
						dispatchEvent(new EventQte(qte));
					iqte ++;
				}
			}
			else
			{
				iqte = 0;
			}
			secPrev = secNow;
		}
	}
}