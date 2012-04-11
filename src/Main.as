package 
{
	import com.adobe.serialization.json.JSON;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author jjp
	 */
	public class Main extends Sprite 
	{
		private var videotube:Videotube;
		private var gamedisc:Gamedisc;
		private var gameeditor:GameEditor;
		private var gameplayer:GamePlayer;
		private var debug:Boolean;
		
		public static var instance:Main;
		
		public function Main():void 
		{
			instance = this;
			if (loaderInfo.parameters.jsonDisc) {
				gamedisc = new Gamedisc();
				gamedisc.FromJson(JSON.decode(loaderInfo.parameters.jsonDisc));
				trace("+++LOADING+++", loaderInfo.parameters.urlPostQte, loaderInfo.parameters.csrf);
				if (loaderInfo.parameters.urlPostQte && loaderInfo.parameters.csrf) {
					gamedisc.setUrlPost(JSON.decode(loaderInfo.parameters.urlPostQte), JSON.decode(loaderInfo.parameters.csrf));
				}
			} else {
				// debugging
				gamedisc = new Gamedisc("The%20Last%20Eichhof%20-%20Longplay.flv", Gamedisc.VIDEOTUBE_FLV);
				debug = true;
			}
			videotube = gamedisc.CreateVideotube();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			addChild(videotube);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKey);
			if (videotube.fready())
				onVideotubeReady();
			else
				videotube.addEventListener(Videotube.READY, onVideotubeReady);
		}
		private function toggleGame():void
		{
			if (gameeditor == null)
			{
				if (gameplayer != null)
				{
					removeChild(gameplayer);
					gameplayer = null;
				}
				
				gameeditor = new GameEditor(videotube, gamedisc);
				addChild(gameeditor);
			}
			else
			{
				removeChild(gameeditor);
				gameeditor = null;
				
				gameplayer = new GamePlayer(videotube, gamedisc);
				addChild(gameplayer);
			}
			videotube.enqueue();
		}
		private function onVideotubeReady(event:Event = null):void
		{
			toggleGame();
			if (!gamedisc.fCanEdit())
				toggleGame();
		}
		private function onKey(key:KeyboardEvent):void
		{
			if (key.keyCode == Keyboard.SPACE && debug)
				toggleGame();
		}
		public function fatalError(message:String):void {
			var text:TextField = Util.addTextFieldFullScreen(this);
			Util.setText(text, message, 64, 0xffffff, 0x440000);
			if (gameplayer)
				removeChild(gameplayer);
			if (gameeditor)
				removeChild(gameeditor);
			if (videotube) {
				videotube.pause();
				removeChild(videotube);
			}
			gameplayer = null;
			gameeditor = null;
			videotube = null;
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKey);
		}
	}
}