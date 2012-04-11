package  
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Security;
	/**
	 * ...
	 * @author jjp
	 */
	public class VideotubeYt extends Videotube
	{
		private var player:Object;
		private var loader:Loader;
		public function VideotubeYt(gamedisc:Gamedisc) 
		{
			super(gamedisc);
			Security.allowDomain("www.youtube.com");
			Security.allowDomain("*.ytimage.com");
			player = null;
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
		}
		private function onLoaderInit(event:Event):void 
		{
			trace("yt: loader init");
			addChild(loader);
			loader.contentLoaderInfo.removeEventListener(Event.INIT, onLoaderInit);
			player = loader.content;
			player.addEventListener("onReady", onPlayerReady);
			player.addEventListener("onStateChange", onStateChange);
			player.addEventListener("onError", onError);
		}
		private function onStateChange(event:Event):void {
			trace("yt: state " + player.getPlayerState());
		}
		private function onError(event:Event):void {
			trace("yt: error", Object(event).data);
		}
		private function onPlayerReady(event:Event):void 
		{
			trace("yt: player ready");
			player = loader.content;
			player.setSize(stage.stageWidth, stage.stageHeight);
			player.cueVideoById(gamedisc.urlVideo);
			
			stage.addEventListener(Event.ENTER_FRAME, tick);
			dispatchEvent(new Event(Videotube.READY));
		}
		public override function fready():Boolean 		{ return player !== null && player.getPlayerState() >= 0; }
		public override function enqueue():void 		{ seek(0); }
		public override function pause():void 			{ player.pauseVideo(); }
		public override function resume():void 			{ player.playVideo(); }
		public override function time():Number 			{ return player.getCurrentTime(); }
		protected override function seekI(sec:Number):void 	{ player.seekTo(sec, true); }
	}
}