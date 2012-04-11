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
		private var stream:NetStream;
		public function VideotubeFlv(gamedisc:Gamedisc)
		{
			super(gamedisc);
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
		public override function fready():Boolean		{ return true; }
		public override function pause():void 			{ stream.pause(); }
		public override function resume():void 			{ stream.resume(); }
		public override function time():Number 			{ return stream.time; }
		protected override function seekI(sec:Number):void 	{ stream.seek(sec); }
		public override function enqueue():void {
			seek(0);
			stream.play(gamedisc.urlVideo); 
			stream.pause();
		}
	}
}