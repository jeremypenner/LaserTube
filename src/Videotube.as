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
		protected function seekI(sec:Number):void	{ throw "not implemented"; }
		
		private var secPrev:Number;
		private var iqte:int;
		private var iqtePrev:int;
		protected var gamedisc:Gamedisc;
		public function Videotube(gamedisc: Gamedisc)
		{
			this.gamedisc = gamedisc;
			secPrev = 0;
			iqte = 0;
			iqtePrev = 0;
		}
		
		public function seek(sec:Number):void
		{
			seekI(sec);
			if (iqtePrev != -1)
			{
				dispatchEvent(new EventQte(EventQte.QTE_CANCEL, gamedisc.rgqte[iqtePrev]));
				iqtePrev = -1;
			}
			iqte = -1;
		}
		// returns true if triggered
		private function Trigger(iqte:int, ev:String, secNow:Number): Boolean
		{
			if (iqte >= 0 && iqte < gamedisc.rgqte.length)
			{
				var qte:Qte = gamedisc.rgqte[iqte];
				var secQte:Number;
				if (ev == EventQte.QTE)
					secQte = qte.secTrigger;
				else
					secQte = qte.secTimeout();
				if (Util.FInTimespan(secQte, secPrev, secNow))
				{
					dispatchEvent(new EventQte(ev, qte));
					return true;
				}
			}
			return false;
		}
		protected function tick(e: Event):void
		{
			var secNow:Number = time();
			var fPrevQteProcessed:Boolean = false;
			var fQteProcessed:Boolean = false;
			if (iqte < 0)
			{
				iqte = Util.binarySearch(gamedisc.rgqte, secNow, function(qte:Qte, secNow:Number):int {
					if (qte.secTrigger < secNow)
						return -1;
					if (qte.secTrigger > secNow)
						return 1;
					return 0;
				});
				iqtePrev = iqte;
			}
			else
			{
				// we loop here so that, in the event of being passed bad data, we still do something vaguely sensible.
				while (!fPrevQteProcessed && !fQteProcessed)
				{
					if (Trigger(iqtePrev, EventQte.QTE_TIMEOUT, secNow))
					{
						fPrevQteProcessed = false;
						iqtePrev ++;
					}
					else
						fPrevQteProcessed = true;
					
					if (Trigger(iqte, EventQte.QTE, secNow))
					{
						fQteProcessed = false;
						iqte ++;
					}
					else
						fQteProcessed = true;
				}
			}
			secPrev = secNow;
		}
	}
}