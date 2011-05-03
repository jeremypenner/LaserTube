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
	public class Main extends Sprite 
	{
		private var clickarea:ClickArea;
		public function Main():void 
		{
			clickarea = new ClickArea([new Point(50, 50), new Point(100, 80), new Point(30, 120)], 0x555555);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			addChild(clickarea);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		private function onClick(e: MouseEvent): void
		{
			if (clickarea.FHit(new Point(e.stageX, e.stageY)))
				clickarea.Toggle();
		}
		
	}
	
}