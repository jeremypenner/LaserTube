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
	public class Videotube extends Sprite
	{
		private var flv:Video;
		private var gamedisc:Gamedisc;
		public var stream:NetStream;
		public function Videotube(gamedisc:Gamedisc)
		{
			super();
			this.gamedisc = gamedisc;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e: Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			flv = new Video(stage.stageWidth, stage.stageHeight);
			addChild(flv);
			var conn:NetConnection = new NetConnection();
			conn.connect(null);
			stream = new NetStream(conn);
			stream.client = new Object();
			flv.attachNetStream(stream);
		}
	}
}