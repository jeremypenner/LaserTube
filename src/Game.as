package 
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
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
		protected var typein:TextField;
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
			stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, preventWidgetFocusChange);
			stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, preventWidgetFocusChange);
			
			clickarea = null;
			typein = null;
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
			stage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, preventWidgetFocusChange);
			stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, preventWidgetFocusChange);
			
			if (hasFocus)
				onPause();
			clearClickarea();
		}
		protected function focussedChild():InteractiveObject {
			return null;
		}
		protected function onFocus(e:Event):void {
			trace("received focus");
			trace(stage.focus);
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
			trace(stage.focus);
			pushText("Paused\nCLICK TO PLAY", 0x000000, 0xFFFFFF);
			hasFocus = false;
			onPause();
		}
		protected function preventWidgetFocusChange(e:Event): void {
			trace("preventing focus change");
			e.preventDefault();
			stage.focus = focussedChild();
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
		public function addClickarea(center:Point, radius:Number):void {
			clearClickarea();
			clickarea = new ClickArea(center, radius, 0x4444ee, 0.4)
			addChild(clickarea);
		}
		public function addTypein(text:String):void {
			clearTypein();
			typein = new TextField();
			typein.x = 0;
			typein.y = stage.stageHeight / 2;
			typein.width = stage.stageWidth;
			typein.height = 64;
			typein.background = true;
			
			Util.setText(typein, text, 40, 0x222222, 0xffffff);
			
			addChild(typein);
		}
		public function clearClickarea(): void
		{
			if (clickarea != null) {
				removeChild(clickarea);
				clickarea = null;				
			}
		}
		public function clearTypein(): void
		{
			if (typein != null) {
				removeChild(typein);
				typein = null;
			}
		}
		public function clearQteUI(): void {
			clearClickarea();
			clearTypein();
		}
		protected function pushText(html:String, bgcolor:int, fgcolor:int): void {
			if (text == null) {
				text = Util.addTextFieldFullScreen(this);
				text.selectable = false;
			}
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