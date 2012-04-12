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
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author jjp
	 */
	public class GamePlayer extends Game
	{
		private var fAlive: Boolean;
		public override function GamePlayer(videotube:Videotube, gamedisc:Gamedisc) {
			super(videotube, gamedisc);
			fAlive = true;
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
			clearClickarea();
			clickarea = new ClickArea(e.qte.center, e.qte.radius, 0x4444ee, 0.4);
			addChild(clickarea);
		}
		private function onTimeout(e:EventQte):void
		{
			trace("gameplayer timeout");
			if (clickarea != null) {
				pushText("OH SHIT\n\nhit R to restart", 0x0000FF, 0xFF0000);
				videotube.pause();
				fAlive = false;
			}
			clearClickarea();
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
			trace("key:", event.keyCode);
		}
	}

}