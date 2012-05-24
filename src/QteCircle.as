package  {
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Jeremy Penner
	 */
	public class QteCircle extends Qte {
		public var center:Point;
		public var radius:Number;
		public function QteCircle(center:Point = null, radius:Number = -1, secTrigger:Number = -1, secTimeout:Number = -1, fDirty:Boolean = false) {
			this.center = center;
			this.radius = radius;
			super(secTrigger, secTimeout, fDirty);
		}
		public function moveTo(center: Point): void
		{
			fDirty = true;
			this.center = center;
		}
		
		protected override function shapeToJson(): Object {
			return { center: [center.x, center.y], radius: radius };
		}
		protected override function setShapeFromJson(shape:Object): void {
			center = new Point(shape.center[0], shape.center[1]);
			radius = shape.radius;
		}
	}

}