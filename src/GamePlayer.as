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
			stage.addEventListener(MouseEvent.CLICK, onClick);
			videotube.addEventListener(EventQte.QTE, onQte);
		}
		private function cleanup(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, cleanup);
			stage.removeEventListener(MouseEvent.CLICK, onClick);
			videotube.removeEventListener(EventQte.QTE, onQte);
		}
		private function onQte(e:EventQte):void
		{
			clickarea = new ClickArea(e.qte.rgpoint, 0xffff00, 0.7);
			addChild(clickarea);
		}
		private function onClick(mouse:MouseEvent):void
		{
			if (clickarea != null && clickarea.FHit(new Point(mouse.stageX, mouse.stageY)))
			{
				removeChild(clickarea);
				clickarea = null;
			}
		}
	}

}