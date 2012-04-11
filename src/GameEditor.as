package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author jjp
	 */
	public class GameEditor extends Game
	{
		protected var qte:Qte;
		public override function GameEditor(videotube:Videotube, gamedisc:Gamedisc) {
			super(videotube, gamedisc);
			qte = null;
		}
		protected override function onResume():void
		{
			super.onResume();
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onDrag);

			videotube.addEventListener(EventQte.QTE, onQteBegin);
			videotube.addEventListener(EventQte.QTE_TIMEOUT, onQteEnd);
			videotube.addEventListener(EventQte.QTE_CANCEL, onQteEnd);
		}
		protected override function onPause():void
		{
			super.onPause();
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
			
			videotube.removeEventListener(EventQte.QTE, onQteBegin);
			videotube.removeEventListener(EventQte.QTE_TIMEOUT, onQteEnd);
			videotube.removeEventListener(EventQte.QTE_CANCEL, onQteEnd);
		}
		protected override function fPlaying():Boolean {
			return true;
		}
		public function onQteBegin(e: EventQte):void
		{
			trace("editor qte begin");
			if (e.qte != qte) {
				Util.assert(qte == null);
				if (qte != null) {
					gamedisc.repostQte(qte);
					clearClickarea();
					qte = null;
				}
				addClickArea(e.qte);	
			}
		}
		public function onQteEnd(e: EventQte):void
		{
			trace("editor qte end");
			Util.assert(qte == e.qte);
			gamedisc.repostQte(qte);
			clearClickarea();
			qte = null;
		}

		public function onKeyUp(key: KeyboardEvent):void
		{
			if (key.keyCode == 46 && qte != null) {// delete
				gamedisc.DeleteQte(qte, videotube);
				clearClickarea();
				qte = null;
			} else if (key.keyCode == 37) { // leftArrow
				videotube.seek(videotube.time() - 3);
				clearClickarea();
				qte = null;
			} else if (key.keyCode == 39) { // rightArrow
				videotube.seek(videotube.time() + 3);
				clearClickarea();
				qte = null;
			}
		}
		private function addClickArea(qteNew: Qte):void
		{
			qte = qteNew;
			clickarea = new ClickArea(qte.center, qte.radius, 0x4444ee, 0.4);
			addChild(clickarea);
		}
		private function moveClickArea(point:Point): void
		{
			if (qte) {
				qte.moveTo(point);
				clickarea.moveTo(point);
			}
		}
		public function onClick(e: MouseEvent):void 
		{
			trace("clicked");
			var point:Point = new Point(e.stageX, e.stageY);
			if (qte)
				moveClickArea(point);
			else {
				var qte:Qte = new Qte(point, 75, videotube.time(), -1, true /*fDirty*/);
				addClickArea(qte);
				gamedisc.AddQte(qte, videotube);
			}
		}
		public function onDrag(e: MouseEvent):void
		{
			if (e.buttonDown)
				moveClickArea(new Point(e.stageX, e.stageY));
		}
	}

}