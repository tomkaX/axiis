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
		
		private var queuedStateChangeEvents:Array = [];
		
		override protected function createChildren():void
		{
			super.createChildren();
			for each(var layout:ILayout in layouts)
			{
				layout.registerOwner(this);
				layout.addEventListener(LayoutEvent.INVALIDATE,handleLayoutInvalidate);
				layout.addEventListener(LayoutEvent.STATE_CHANGE,handleLayoutStateChange);
				
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
				
				// Remove queued state changes if they've been taken care of by layout.render
				for(var a:int = 0; a < queuedStateChangeEvents.length; a++)
				{
					var currStateEvent:LayoutEvent = LayoutEvent(queuedStateChangeEvents[a]);
					if(currStateEvent.layout == layout)
					{
						queuedStateChangeEvents.splice(a,1);
						a--;
					}
				}
			}
			
			// Apply any necessary state changes
			while(queuedStateChangeEvents.length > 0)
			{
				var stateEvent:LayoutEvent = LayoutEvent(queuedStateChangeEvents.pop());
				stateEvent.layout.renderAlteredStateSprites();
			}
		}
		
		protected function handleLayoutInvalidate(event:LayoutEvent):void
		{
			invalidatedLayouts.push(event.layout);
			super.invalidateDisplayList();
		}
		
		protected function handleLayoutStateChange(event:LayoutEvent):void
		{
			queuedStateChangeEvents.push(event);
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