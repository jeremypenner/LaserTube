package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author jjp
	 */
	public class GameEditor extends Sprite
	{
		private var videotube:Videotube;
		private var gamedisc:Gamedisc;
		private var sketchShape:SketchShape;
		private var clickarea:ClickArea;
		
		public function GameEditor(videotube:Videotube, gamedisc:Gamedisc) 
		{
			this.videotube = videotube;
			this.gamedisc = gamedisc;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function init(e: Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, cleanup);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			sketchShape = new SketchShape();
			addChild(sketchShape);
			sketchShape.addEventListener(SketchShape.DRAW_BEGIN, onDrawBegin);
			sketchShape.addEventListener(SketchShape.DRAW_END, onDrawEnd);
			
			clickarea = null;
			videotube.addEventListener(EventQte.QTE, onQteBegin);
			videotube.addEventListener(EventQte.QTE_TIMEOUT, onQteEnd);
		}
		public function cleanup(e: Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, cleanup);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			sketchShape.removeEventListener(SketchShape.DRAW_BEGIN, onDrawBegin);
			sketchShape.removeEventListener(SketchShape.DRAW_END, onDrawEnd);
		}
		public function onQteBegin(e: EventQte):void
		{
			clickarea = new ClickArea(e.qte.rgpoint, 0x4444ee, 0.4);
			addChild(clickarea);
		}
		public function onQteEnd(e: EventQte):void
		{
			removeChild(clickarea);
			clickarea = null;
		}
		public function onKeyUp(key: KeyboardEvent):void
		{
			
		}
		private function onDrawBegin(e: Event): void
		{
			videotube.pause();
		}
		private function onDrawEnd(e: Event): void
		{
			gamedisc.AddQte(new Qte(sketchShape.rgpoint, videotube.time()));
			videotube.resume();
		}

	}

}