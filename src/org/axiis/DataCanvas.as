package org.axiis
{
	import flash.display.Sprite;
	
	import mx.core.UIComponent;
	
	import org.axiis.core.ILayout;
	import org.axiis.events.LayoutEvent;
	
	public class DataCanvas extends UIComponent
	{
		public function DataCanvas()
		{
			super();
		}
		
		[Bindable]
		public var fills:Array = [];
		
		[Bindable]
		public var strokes:Array = [];
		
		[Bindable]
		public var dataProviders:Array= [];
		
		[Bindable]
		public var layouts:Array = [];
		
		override protected function createChildren():void
		{
			super.createChildren();
			for each(var layout:ILayout in layouts)
			{
				layout.registerOwner(this);
				layout.initializeGeometry();
				layout.addEventListener(LayoutEvent.INVALIDATE,handleLayoutInvalidate);
				var sprite:Sprite = layout.getSprite(this);
				addChild(sprite);
			}
		}
		
		/**
		 * TODO implement measure
		 */
		override protected function measure():void
		{
			super.measure();
			
			for each(var layout:ILayout in layouts)
			{
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			graphics.clear();
			//graphics.lineStyle(1);
			//graphics.drawRect(0,0,width,height);
			for each(var layout:ILayout in layouts)
			{
				// This will have to change
				//layout.width = width;
				//layout.height = height;
				
				layout.render();
			}
		}
		
		protected function handleLayoutInvalidate(event:LayoutEvent):void
		{
			invalidateSize();
			invalidateDisplayList();
		}
	}
}