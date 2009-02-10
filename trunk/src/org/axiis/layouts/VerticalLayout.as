package org.axiis.layouts
{
	import com.degrafa.geometry.Geometry;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.axiis.core.BoxLayout;
	import org.axiis.core.ILayout;
	
	public class VerticalLayout extends BoxLayout implements ILayout
	{
		public function VerticalLayout()
		{
			super();
		}
		
		[Bindable(event="verticalAlignChange")]
		[Inspectable(category="General", enumeration="top,botton", defaultValue="top")]
		public function set verticalAlign(value:String):void
		{
			if(value != _verticalAlign)
			{
				_verticalAlign = value;
				invalidate();
				dispatchEvent(new Event("verticalAlignChange"));
			}
		}
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		private var _verticalAlign:String = "top";
		
		override public function renderDatum(datum:Object,targetSprite:Sprite,rectangle:Rectangle):void
		{
			targetSprite.graphics.clear();
			
			if(!geometries)
				return
				
			var len:int = geometries.length;
			for each(var geometry:Geometry in geometries)
			{
				// Store copies of the property we'll need to manipulate
				var originalY:Number = geometry.y;
				
				// Move the geometry...
				geometry.y = geometry.y + currPos;
				if(verticalAlign == "bottom")
					geometry.y = height - geometry.y - geometry.height;
				
				geometry.draw(targetSprite.graphics,rectangle);
				
				// Reset the y property
				geometry.y = originalY;
				
				currPos += geometry.height + gap;
			}
			
			// Call to sub-layouts' renderDatum methods here
		}
	}
}