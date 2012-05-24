package  
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author jjp
	 */
	public class GameEditor extends Game
	{
		protected var qte:Qte;
		protected var fTyping:Boolean;
		public override function GameEditor(videotube:Videotube, gamedisc:Gamedisc) {
			super(videotube, gamedisc);
			qte = null;
		}
		protected override function onResume():void
		{
			super.onResume();
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
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
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
			
			videotube.removeEventListener(EventQte.QTE, onQteBegin);
			videotube.removeEventListener(EventQte.QTE_TIMEOUT, onQteEnd);
			videotube.removeEventListener(EventQte.QTE_CANCEL, onQteEnd);
		}
		
		override protected function focussedChild():InteractiveObject {
			if (typein)
				return typein;
			return super.focussedChild();
		}
		protected override function fPlaying():Boolean {
			return !fTyping;
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
				qte = e.qte;
				if (e.qteCircle()) {
					addClickarea(e.qteCircle().center, e.qteCircle().radius);
				} else if (e.qteText()) {
					addTypein(e.qteText().text);
				}
			}
		}
		public function onQteEnd(e: EventQte):void
		{
			trace("editor qte end");
			Util.assert(qte == e.qte);
			gamedisc.repostQte(qte);
			clearQteUI();
			qte = null;
		}

		public function onKeyUp(key: KeyboardEvent):void
		{
			if (!fTyping) {
				if (key.keyCode == 46 && qte != null) {// delete
					gamedisc.DeleteQte(qte, videotube);
					clearQteUI();
					qte = null;
				} else if (key.keyCode == 37) { // leftArrow
					videotube.seek(videotube.time() - 3);
					clearQteUI();
					qte = null;
				} else if (key.keyCode == 39) { // rightArrow
					videotube.seek(videotube.time() + 3);
					clearQteUI();
					qte = null;
				}
			} else {
				Util.assert(qte as QteText);
				if (key.keyCode == 13) { // enter
					var text:String = typein.text;
					if (text.length > 0) {
						trace("Creating QTE: " + text);
						var qteText:QteText = qte as QteText;
						qteText.text = text;
						// 300ms per character + 500ms reaction time
						qteText.msTimeout = ((text.length * 300) + 500) + qteText.msTrigger;
						gamedisc.AddQte(qteText, videotube);
						gamedisc.repostQte(qteText);
						
					} else {
						gamedisc.DeleteQte(qte, videotube);
						qte = null;
						clearTypein();
					}
					stage.focus = this;
					fTyping = false;
					videotube.resume();
				}
			}
		}
		private function onKeyDown(key:KeyboardEvent): void {
			if (!fTyping && qte == null) {
				if (key.charCode >= 0x20 && key.charCode <= 0x7e) { // printable character
					var ch:String = String.fromCharCode(key.charCode);
					trace("typed character: '" + ch + "'");
					qte = new QteText(ch, videotube.time(), videotube.time() + 0.1, /*fDirty*/true);
					addTypein(ch);
					typein.type = TextFieldType.INPUT;
					trace("focusing");
					stage.focus = typein;
					typein.setSelection(ch.length, ch.length);
					fTyping = true;
					videotube.pause();
				}
			}
		}
		private function moveClickArea(point:Point): void
		{
			var qteCircle:QteCircle = qte as QteCircle;
			if (qteCircle) {
				qteCircle.moveTo(point);
				clickarea.moveTo(point);
			}
		}
		public function onClick(e: MouseEvent):void 
		{
			if (!fTyping) {
				trace("clicked" + qte);
				var point:Point = new Point(e.stageX, e.stageY);
				if (qte)
					moveClickArea(point);
				else {
					var qte:QteCircle = new QteCircle(point, 75, videotube.time(), -1, true /*fDirty*/);
					addClickarea(qte.center, qte.radius);
					this.qte = qte;
					gamedisc.AddQte(qte, videotube);
				}
			}
		}
		public function onDrag(e: MouseEvent):void
		{
			if (e.buttonDown)
				moveClickArea(new Point(e.stageX, e.stageY));
		}
	}

}