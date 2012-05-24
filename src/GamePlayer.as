package  
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author jjp
	 */
	public class GamePlayer extends Game
	{
		private var fAlive: Boolean;
		private var ichNext: int;
		public override function GamePlayer(videotube:Videotube, gamedisc:Gamedisc) {
			super(videotube, gamedisc);
			fAlive = true;
			ichNext = -1;
		}
		protected override function onResume():void
		{
			super.onResume();
			addEventListener(MouseEvent.CLICK, onClick);
			videotube.addEventListener(EventQte.QTE, onQte);
			videotube.addEventListener(EventQte.QTE_TIMEOUT, onTimeout);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKey);
		}
		protected override function onPause():void
		{
			super.onPause();
			removeEventListener(MouseEvent.CLICK, onClick);
			videotube.removeEventListener(EventQte.QTE, onQte);
			videotube.removeEventListener(EventQte.QTE_TIMEOUT, onTimeout);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKey);
		}
		protected override function fPlaying():Boolean {
			return fAlive;
		}
		private function onQte(e:EventQte):void
		{
			trace(e.qte.secTrigger() + "gameplayer start" + e.qte.secTimeout());
			trace(e.qte);
			clearQteUI();
			if (e.qteCircle()) {
				addClickarea(e.qteCircle().center, e.qteCircle().radius);
			} else if (e.qteText()) {
				addTypein(e.qteText().text);
				typein.type = TextFieldType.DYNAMIC;
				typein.selectable = false;
				ichNext = 0;
			}
		}
		private function onTimeout(e:EventQte):void
		{
			trace("gameplayer timeout");
			if (clickarea != null || typein != null) {
				pushText("OH SHIT\n\nhit R to restart", 0x0000FF, 0xFF0000);
				videotube.pause();
				fAlive = false;
			}
			clearQteUI();
		}
		private function onClick(mouse:MouseEvent):void
		{
			if (clickarea != null && clickarea.FHit(new Point(mouse.stageX, mouse.stageY)))
				clearClickarea();
		}
		private function onKey(event:KeyboardEvent):void {
			if (!fAlive && event.keyCode == 82) {
				fAlive = true;
				popText();
				videotube.seek(0);
				videotube.resume();
			}
			if (typein != null) {
				var text:String = typein.text;
				var ch:String = String.fromCharCode(event.charCode).toLowerCase();
				var chToMatch:String = text.substr(ichNext, 1).toLowerCase();
				trace(chToMatch + ":" + ch);
				if (ch == chToMatch) {
					ichNext ++;
					if (ichNext >= text.length) {
						clearTypein();
						ichNext = -1;
					} else {
						var format:TextFormat = new TextFormat();
						format.size = 40;
						format.color = 0xFFFF00;
						typein.setTextFormat(format, 0, ichNext);
					}
				}
			}
			trace("key:", event.keyCode);
		}
	}
}