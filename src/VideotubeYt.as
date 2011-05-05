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
			player = null;
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
		}
		private function onLoaderInit(event:Event):void 
		{
			addChild(loader);
			loader.contentLoaderInfo.removeEventListener(Event.INIT, onLoaderInit);
			loader.content.addEventListener("onReady", onPlayerReady);
		}
		private function onPlayerReady(event:Event):void 
		{
			player = loader.content;
			player.setSize(stage.stageWidth, stage.stageHeight);
			player.cueVideoById(gamedisc.urlVideo);
			
			stage.addEventListener(Event.ENTER_FRAME, tick);
			dispatchEvent(new Event(Videotube.READY));
		}
		public override function fready():Boolean 		{ return player !== null; }
		public override function play():void 			{ player.playVideo(); }
		public override function pause():void 			{ player.pauseVideo(); }
		public override function resume():void 			{ player.playVideo(); }
		public override function time():Number 			{ return player.getCurrentTime(); }
		public override function seek(sec:Number):void 	{ player.seekTo(sec, true); }
	}
}