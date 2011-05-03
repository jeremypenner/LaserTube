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
		private var sketchShape:SketchShape;
		private var videotube:Videotube;
		public function Main():void 
		{
			clickarea = new ClickArea([new Point(50, 50), new Point(100, 80), new Point(30, 120)], 0x555555);
			sketchShape = new SketchShape();
			videotube = new Videotube();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			addChild(videotube);
			addChild(clickarea);
			addChild(sketchShape);
			addEventListener(MouseEvent.CLICK, onClick);
			sketchShape.addEventListener(SketchShape.DRAW_BEGIN, onShapeBegin);
			sketchShape.addEventListener(SketchShape.DRAW_END, onShapeComplete);
			videotube.stream.play("The Last Eichhof - Longplay.flv");
		}
		private function onClick(e: MouseEvent): void
		{
			if (clickarea.FHit(new Point(e.stageX, e.stageY)))
				clickarea.Toggle();
		}
		private function onShapeBegin(e: Event): void
		{
			videotube.stream.pause();
		}
		private function onShapeComplete(e: Event): void
		{
			addChild(new ClickArea(sketchShape.rgpoint, 0x883388, 0.5));
			videotube.stream.resume();
		}
	}
}