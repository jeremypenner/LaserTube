package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author jjp
	 */
	public class Videotube extends Sprite
	{
		public static const READY:String = "videotube-ready";
		private static const DEBUG_VIDEO:Boolean = false;
		
		public function fready():Boolean			{ throw "not implemented"; }
		public function enqueue():void				{ throw "not implemented"; }
		public function pause():void				{ throw "not implemented"; }
		public function resume():void				{ throw "not implemented"; }
		public function time():Number				{ throw "not implemented"; }
		protected function seekI(sec:Number):void	{ throw "not implemented"; }
		
		private var secPrev:Number;
		private var iqte:int;
		private var qtePrev:Qte;
		protected var gamedisc:Gamedisc;
		private var textDebug:TextField;
		public function Videotube(gamedisc: Gamedisc)
		{
			this.gamedisc = gamedisc;
			secPrev = 0;
			iqte = 0;
			qtePrev = null;
			if (DEBUG_VIDEO) {
				textDebug = new TextField();
				textDebug.x = 0;
				textDebug.y = 0;
				textDebug.width = 640;
				textDebug.height = 70;
			}
		}
		
		public function seek(sec:Number):void
		{
			trace("seeking");
			seekI(sec);
			cancelPrev();
			iqte = -1;
			trace("seek to " + sec + ":" + iqte);
		}
		// returns true if triggered
		private function Trigger(qte:Qte, ev:String, secNow:Number): Boolean
		{
			if (qte != null)
			{
				var secQte:Number;
				if (ev == EventQte.QTE)
					secQte = qte.secTrigger();
				else
					secQte = qte.secTimeout();
				//trace("testing " + iqte + " for " + ev + " " + secQte + " in " + secPrev + ":" + secNow);
				if (Util.FInTimespan(secQte, secPrev, secNow))
				{
					trace("triggered " + ev);
					dispatchEvent(new EventQte(ev, qte));
					return true;
				}
			}
			return false;
		}
		protected function cancelPrev():void {
			if (qtePrev != null) {
				dispatchEvent(new EventQte(EventQte.QTE_CANCEL, qtePrev));
				qtePrev = null;
			}
		}
		protected function tick(e: Event):void
		{
			var secNow:Number = time();
			var fPrevQteProcessed:Boolean = false;
			var fQteProcessed:Boolean = false;
			if (secNow < secPrev) {
				iqte = -1;
				cancelPrev();
				secPrev = secNow;
			}
			if (iqte < 0)
			{
				trace("finding qte for time " + secNow);
				iqte = Math.abs(Util.binarySearch(gamedisc.rgqte, secNow, function(qte:Qte, secNow:Number):int {
					if (qte.secTrigger() < secNow)
						return -1;
					if (qte.secTrigger() > secNow)
						return 1;
					return 0;
				}));
				cancelPrev();
				if (iqte < gamedisc.rgqte.length)
					trace("found: " + iqte + " at " + gamedisc.rgqte[iqte].secTrigger());
				else
					trace("at end of qtes");
			}
			else
			{
				// we loop here so that, in the event of being passed bad data, we still do something vaguely sensible.
				while (!fPrevQteProcessed && !fQteProcessed)
				{
					//trace(secNow + ":: prev" + iqtePrev + ", iqte" + iqte);
					if (Trigger(qtePrev, EventQte.QTE_TIMEOUT, secNow))
					{
						fPrevQteProcessed = false;
						qtePrev = null;
					}
					else
						fPrevQteProcessed = true;
					
					var qte:Qte = null;
					if (iqte >= 0 && iqte < gamedisc.rgqte.length)
						qte = gamedisc.rgqte[iqte];
					if (Trigger(qte, EventQte.QTE, secNow))
					{
						Util.assert(qtePrev == null);
						fQteProcessed = false;
						iqte ++;
						qtePrev = qte;
					}
					else
						fQteProcessed = true;
				}
			}
			if (DEBUG_VIDEO) {
				var txt:String = int(secNow * 1000) + "ms";
				if (iqte < gamedisc.rgqte.length)
					txt += " | next qte at " + gamedisc.rgqte[iqte].msTrigger;
				if (qtePrev != null)
					txt += " | qte over at " + qtePrev.msTimeout;
				textDebug.htmlText = txt;
				textDebug.backgroundColor = 0x000000;
				textDebug.setTextFormat(new TextFormat(null, 16, 0xffffff));
				if (textDebug.parent == this)
					removeChild(textDebug);
				addChild(textDebug);				
			}
			
			secPrev = secNow;
		}
		public function onQtesChanged(iqteNext: int, qtePrev:Qte): void {
			iqte = iqteNext;
			cancelPrev();
			this.qtePrev = qtePrev;
		}
	}
}