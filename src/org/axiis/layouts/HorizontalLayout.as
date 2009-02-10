package org.axiis.layouts
{
	import com.degrafa.geometry.Geometry;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.axiis.core.BoxLayout;
	import org.axiis.core.ILayout;
	
	public class HorizontalLayout extends BoxLayout implements ILayout
	{
		public function HorizontalLayout()
		{
			super();
		}
		
		[Bindable(event="horizontalAlignChange")]
		[Inspectable(category="General", enumeration="left,right", defaultValue="left")]
		public function set horizontalAlign(value:String):void
		{
			if(value != _horizontalAlign)
			{
				_horizontalAlign = value;
				invalidate();
				dispatchEvent(new Event("horizontalAlignChange"));
			}
		}
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		private var _horizontalAlign:String = "left";
		
		override public function renderDatum(datum:Object,targetSprite:Sprite,rectangle:Rectangle):void
		{
			targetSprite.graphics.clear();
			
			if(!geometries)
				return;
			
			var len:int = geometries.length;
			for each(var geometry:Geometry in geometries)
			{
				var originalX:Number = geometry.x;
				var originalWidth:Number = geometry.width;
				
				geometry.x = geometry.x + currPos;
				
				if(horizontalAlign == "right")
					geometry.x = width - geometry.x - geometry.width;
				
				geometry.draw(targetSprite.graphics,rectangle);
				geometry.x = originalX;
				
				currPos += geometry.width + gap;
			}
		}
	}
}