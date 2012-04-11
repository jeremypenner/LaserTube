package  
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * Represents a spot on the screen where the user can click.
	 * @author jjp
	 */
	public class ClickArea extends Sprite
	{
		private var shape:Shape;
		private var shapeHidden:Shape;
		private var fHidden:Boolean;
		public function ClickArea(center: Point, radius:Number, color:uint, alpha:Number = 1)
		{
			super();
			shape = drawShape(new Shape(), new Point(0,0), radius, color, null, alpha);
			shapeHidden = drawShape(new Shape(), new Point(0,0), radius, color, null, 0);
			fHidden = false;
			moveTo(center);
			addChild(shape);
		}
		public function moveTo(centerNew: Point):void
		{
			x = centerNew.x;
			y = centerNew.y;
		}
		public static function drawShape(shape:Shape, center:Point, radius:Number, color:uint, colorLine:* = null, alpha:Number = 1):Shape
		{
			shape.graphics.clear();
			shape.graphics.beginFill(color, alpha);
			shape.graphics.drawCircle(center.x, center.y, radius);
			shape.graphics.endFill();
			return shape;
		}
		public function Show():void
		{
			if (fHidden)
			{
				removeChild(shapeHidden);
				addChild(shape);
				fHidden = false;
			}
		}
		public function Hide():void
		{
			if (!fHidden)
			{
				removeChild(shape);
				addChild(shapeHidden);
				fHidden = true;
			}
		}
		public function Toggle(): void
		{
			if (fHidden)
				Show();
			else
				Hide();
		}
		public function FHit(point:Point):Boolean
		{
			var shape:Shape;
			if (!fHidden)
				shape = this.shape;
			else
				shape = this.shapeHidden;
			return shape.hitTestPoint(point.x, point.y, true);
		}
	}
}