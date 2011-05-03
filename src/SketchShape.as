package  
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author jjp
	 */
	public class SketchShape extends Sprite
	{
		public var rgpoint: Array;
		private var shape: Shape;
		private var shapeLine: Shape;
		private var msClickLast: int;
		
		public static const DRAW_BEGIN:String = "draw-begin";
		public static const DRAW_END:String = "draw-end";
		
		public function SketchShape() 
		{
			super();
			rgpoint = [];
			shape = new Shape();
			shapeLine = null;
			msClickLast = -1;
			addChild(shape);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e: Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.doubleClickEnabled = true;
			stage.addEventListener(MouseEvent.CLICK, onClick);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		public function clear():void
		{
			rgpoint = [];
			if (shapeLine !== null)
			{
				removeChild(shapeLine);
				shapeLine = null;
			}
			redrawShape();
		}
		private function onClick(e: MouseEvent):void
		{
			var msClickNow:int = getTimer();
			var dmsClick:int = msClickNow - msClickLast;
			if (dmsClick < 200)
			{
				dispatchEvent(new Event(DRAW_END));
				clear();
			}
			else
			{
				if (shapeLine === null)
				{
					shapeLine = new Shape();
					addChild(shapeLine);
					dispatchEvent(new Event(DRAW_BEGIN));
				}
				rgpoint.push(new Point(e.stageX, e.stageY));
				redrawShape();
			}
			msClickLast = msClickNow;
		}
		private function onMove(e: MouseEvent):void
		{
			if (shapeLine !== null)
				redrawLine(new Point(e.stageX, e.stageY));
		}
		private function redrawShape():void
		{
			ClickArea.drawShape(shape, rgpoint, 0x555555, 0x000000, 0.1);
		}
		private function redrawLine(ptEnd:Point):void
		{
			var ptStart:Point = rgpoint[rgpoint.length - 1];
			shapeLine.graphics.clear();
			shapeLine.graphics.lineStyle(1);
			shapeLine.graphics.moveTo(ptStart.x, ptStart.y);
			shapeLine.graphics.lineTo(ptEnd.x, ptEnd.y);
		}
	}

}