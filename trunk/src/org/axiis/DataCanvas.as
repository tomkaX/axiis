package org.axiis
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	import org.axiis.core.ILayout;
	import org.axiis.events.LayoutEvent;
	import org.axiis.events.StateChangeEvent;
	
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
		public var palettes:Array = [];
		
		public var labelFunction:Function;
		
		public var dataFunction:Function;
		
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
		
		[Bindable(event="layoutsChange")]
		public function set layouts(value:Array):void
		{
			if(value != _layouts)
			{
				for each(var oldLayout:ILayout in layouts)
				{
					oldLayout.removeEventListener(StateChangeEvent.STATE_CHANGE,handleStateChange)
				}
				_layouts = value;
				for each(var newLayout:ILayout in layouts)
				{
					newLayout.addEventListener(StateChangeEvent.STATE_CHANGE,handleStateChange,true);
				}
				dispatchEvent(new Event("layoutsChange"));
			}
		}
		public function get layouts():Array
		{
			return _layouts;
		}
		private var _layouts:Array;
		
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
		
		private function handleStateChange(event:StateChangeEvent):void
		{
			trace("state change DataCanvas");
			for each(var layout:ILayout in event.layoutChain)
			{
				trace(" " + layout["name"]);
			}
			trace(" " + event.target.name);
		}
		
		/****   ITEM EVENTS ****/
		public function onItemMouseOver(e:MouseEvent):void {
			trace("mouseOver");
		}
		
		public function onItemMouseOut(e:MouseEvent):void {
			//trace("mouseOut");
		}
		
		public function onItemMouseDown(e:MouseEvent):void {
			//trace("mouseDown");
		}
		
		public function onItemMouseUp(e:MouseEvent):void {
			//trace("mouseUp");
		}

		public function onItemMouseClick(e:MouseEvent):void {
			//trace("mouseClick");
		}
		
		public function onItemMouseDoubleClick(e:MouseEvent):void {
			//trace("mouseDoubleClick");
		}
	}
}