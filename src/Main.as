package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author jjp
	 */
	public class Main extends Sprite 
	{
		private var videotube:Videotube;
		private var gamedisc:Gamedisc;
		private var gameeditor:GameEditor;
		
		public function Main():void 
		{
			gamedisc = new Gamedisc("The Last Eichhof - Longplay.flv");
			videotube = new Videotube(gamedisc);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			gameeditor = new GameEditor(videotube, gamedisc);
			addChild(videotube);
			addChild(gameeditor);
			videotube.stream.play(gamedisc.urlVideo);
		}
	}
}