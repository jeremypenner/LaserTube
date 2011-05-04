package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	/**
	 * ...
	 * @author jjp
	 */
	public class VideotubeFlv extends Videotube
	{
		private var flv:Video;
		private var gamedisc:Gamedisc;
		private var stream:NetStream;
		private var iqte:int;
		private var secPrev:Number;
		public function VideotubeFlv(gamedisc:Gamedisc)
		{
			super();
			this.gamedisc = gamedisc;
			iqte = 0;
			secPrev = 0;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e: Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, cleanup);
			
			flv = new Video(stage.stageWidth, stage.stageHeight);
			addChild(flv);
			var conn:NetConnection = new NetConnection();
			conn.connect(null);
			stream = new NetStream(conn);
			stream.client = new Object();
			flv.attachNetStream(stream);
			
			stage.addEventListener(Event.ENTER_FRAME, tick);
		}
		private function cleanup(e: Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, cleanup);
			stage.removeEventListener(Event.ENTER_FRAME, tick);
		}
		private function tick(e: Event):void
		{
			var secNow:Number = stream.time;
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
		public override function play():void 			{ stream.play(gamedisc.urlVideo); }
		public override function pause():void 			{ stream.pause(); }
		public override function resume():void 			{ stream.resume(); }
		public override function time():Number 			{ return stream.time; }
		public override function seek(sec:Number):void 	{ stream.seek(sec); }
	}
}