package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Jeremy Penner
	 */
	public class Game extends Sprite 
	{
		public static var hasFocus:Boolean = false;
		
		protected var videotube:Videotube;
		protected var gamedisc:Gamedisc;
		protected var clickarea:ClickArea;
		protected var text:TextField;
		protected var textValues: Array;
		public function Game(videotube:Videotube, gamedisc:Gamedisc) 
		{
			this.videotube = videotube;
			this.gamedisc = gamedisc;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		protected function init(e:Event):void {
			trace("init");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, cleanup);
			
			stage.addEventListener(Event.ACTIVATE, onFocus);
			stage.addEventListener(Event.DEACTIVATE, onLoseFocus);
			
			clickarea = null;
			if (text != null)
				removeChild(text);
			text = null;
			textValues = [];
			
			if (hasFocus) {
				onFocus(null);
			} else {
				onLoseFocus(null);
			}
		}
		protected function cleanup(e:Event):void {
			trace("cleanup");
			removeEventListener(Event.REMOVED_FROM_STAGE, cleanup);
			
			stage.removeEventListener(Event.ACTIVATE, onFocus);
			stage.removeEventListener(Event.DEACTIVATE, onLoseFocus);
			
			if (hasFocus)
				onPause();
			clearClickarea();
		}
		protected function onFocus(e:Event):void {
			trace("received focus");
			popText();
			hasFocus = true;
			stage.addEventListener(Event.EXIT_FRAME, onFocusEnded);
		}
		protected function onFocusEnded(e:Event): void {
			stage.removeEventListener(Event.EXIT_FRAME, onFocusEnded);
			onResume();
		}
		protected function onLoseFocus(e:Event): void {
			trace("lost focus");
			pushText("Paused\nCLICK TO PLAY", 0x000000, 0xFFFFFF);
			hasFocus = false;
			onPause();
		}

		protected function onPause(): void { 
			trace("onPause");
			videotube.pause();
		}
		protected function onResume(): void {
			trace("onResume");
			if (fPlaying())
				videotube.resume();
		}
		protected function fPlaying(): Boolean {
			return false;
		}
		public function clearClickarea(): void
		{
			if (clickarea != null) {
				removeChild(clickarea);
				clickarea = null;				
			}
		}
		protected function pushText(html:String, bgcolor:int, fgcolor:int): void {
			if (text == null)
				text = Util.addTextFieldFullScreen(this);
			textValues.push( { 'html': html, 'bgcolor':bgcolor, 'fgcolor':fgcolor } );
			trace("saying: " + html);
			Util.setText(text, html, 164, bgcolor, fgcolor);
		}
		protected function popText(): void {
			if (textValues.length > 0) {
				textValues.pop();
				if (textValues.length > 0) {
					var val:Object = textValues.pop();
					pushText(val['html'], val['bgcolor'], val['fgcolor']);
				} else {
					removeChild(text);
					text = null;
				}
			}
		}
	}
	
}