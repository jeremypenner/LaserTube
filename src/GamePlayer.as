package  
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author jjp
	 */
	public class GamePlayer extends Sprite
	{
		private var videotube:Videotube;
		private var gamedisc:Gamedisc;
		private var clickarea:ClickArea;
		public function GamePlayer(videotube:Videotube, gamedisc:Gamedisc) 
		{
			this.videotube = videotube;
			this.gamedisc = gamedisc;
			clickarea = null;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, cleanup);
			
			addEventListener(MouseEvent.CLICK, onClick);
			videotube.addEventListener(EventQte.QTE, onQte);
			videotube.addEventListener(EventQte.QTE_TIMEOUT, onTimeout);
		}
		private function cleanup(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, cleanup);
			removeEventListener(MouseEvent.CLICK, onClick);
			videotube.removeEventListener(EventQte.QTE, onQte);
		}
		private function onQte(e:EventQte):void
		{			
			clearClickarea();
			clickarea = new ClickArea(e.qte.rgpoint, 0xffff00, 0.7);
			addChild(clickarea);
		}
		private function onTimeout(e:EventQte):void
		{
			if (clickarea != null)
			{
				// fail
			}
			clearClickarea();
		}
		private function onClick(mouse:MouseEvent):void
		{
			if (clickarea != null && clickarea.FHit(new Point(mouse.stageX, mouse.stageY)))
				clearClickarea();
		}
		private function clearClickarea():void
		{
			if (clickarea != null)
			{
				removeChild(clickarea);
				clickarea = null;
			}
		}
	}

}