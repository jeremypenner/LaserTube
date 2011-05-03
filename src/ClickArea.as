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
		public function ClickArea(rgpoint: Array, color:uint, alpha:Number = 1)
		{
			super();
			shape = MakeShape(rgpoint, color, alpha);
			shapeHidden = MakeShape(rgpoint, color, 0);
			fHidden = false;
			addChild(shape);
		}
		private function MakeShape(rgpoint:Array, color:uint, alpha:Number):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(color, alpha);
			var fFirstPoint:Boolean = true;
			for each (var point:Point in rgpoint)
			{
				if (fFirstPoint)
				{
					shape.graphics.moveTo(point.x, point.y);
					fFirstPoint = false;
				}
				else
				{
					shape.graphics.lineTo(point.x, point.y);
				}
			}
			shape.graphics.lineTo(rgpoint[0].x, rgpoint[0].y);
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