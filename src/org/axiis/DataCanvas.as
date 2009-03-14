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
		
		[Bindable(event="dataProviderChange")]
		public function set dataProvider(value:Object):void
		{
			if(value != _dataProvider)
			{
				_dataProvider = value;
				invalidateDisplayList();
				dispatchEvent(new Event("dataProviderChange"));
			}
		}
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		private var _dataProvider:Object;
		
		[Bindable]
		public var layouts:Array = [];
		
		private var invalidatedLayouts:Array = [];
		
		override protected function createChildren():void
		{
			super.createChildren();
			for each(var layout:ILayout in layouts)
			{
				layout.registerOwner(this);
				layout.addEventListener(LayoutEvent.INVALIDATE,handleLayoutInvalidate);
				
				var sprite:Sprite = layout.getSprite(this);
				addChild(sprite);
				
				invalidatedLayouts.push(layout);
			}
		}
		
		/**
		 * TODO implement measure
		 * 
		 * For now we can just set some defaults
		 */
		override protected function measure():void
		{
			super.measure();
			measuredWidth = 400;
			measuredHeight = 400;
		}
		
		override public function invalidateDisplayList():void
		{
			invalidateAllLayouts();
		} 
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			while(invalidatedLayouts.length > 0)
			{
				var layout:ILayout = ILayout(invalidatedLayouts.pop());
				layout.render();
			}
		}
		
		protected function handleLayoutInvalidate(event:LayoutEvent):void
		{
			invalidatedLayouts.push(event.layout);
			super.invalidateDisplayList();
		}
		
		protected function invalidateAllLayouts():void
		{
			for each(var layout:ILayout in layouts)
			{
				invalidatedLayouts.push(layout);
			}
			super.invalidateDisplayList();
		}
	}
}