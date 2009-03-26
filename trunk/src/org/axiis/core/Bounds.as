package org.axiis.core
{
	import flash.geom.Rectangle;
	
	[Bindable]
	public class Bounds
	{
		public function Bounds(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
	}
}