package org.axiis
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.IToolTip;
	import mx.core.UIComponent;
	import mx.managers.ToolTipManager;
	import mx.skins.halo.ToolTipBorder;
	import mx.styles.IStyleClient;
	
	import org.axiis.core.AxiisSprite;
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
		public var palettes:Array = [];
		
		public var labelFunction:Function;
		
		public var dataFunction:Function;
		
		public var toolTipFunction:Function;
		
		public var showToolTips:Boolean = true;
		
		public var toolTipClass:IFactory;
		
		private var tt:IToolTip;
		
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
		
		public var layouts:Array;
		
		private var invalidatedLayouts:Array = [];
		
		override protected function createChildren():void
		{
			super.createChildren();
			for each(var layout:ILayout in layouts)
			{
				layout.registerOwner(this);
				var sprite:Sprite = layout.getSprite(this);
				addChild(sprite);
				
				layout.addEventListener(LayoutEvent.INVALIDATE,handleLayoutInvalidate);
				sprite.addEventListener(MouseEvent.MOUSE_OVER,onItemMouseOver);
				sprite.addEventListener(MouseEvent.CLICK,onItemMouseClick);
				sprite.addEventListener(MouseEvent.DOUBLE_CLICK,onItemMouseDoubleClick);
				sprite.addEventListener(MouseEvent.MOUSE_OUT,onItemMouseOut);
				sprite.addEventListener(MouseEvent.MOUSE_DOWN,onItemMouseDown);
				sprite.addEventListener(MouseEvent.MOUSE_UP,onItemMouseUp);
		
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
		
		/****   ITEM EVENTS ****/
		public function onItemMouseOver(e:MouseEvent):void
		{
			var axiisSprite:AxiisSprite = e.target as AxiisSprite;
			if(!axiisSprite)
				return;
				
			if(showToolTips && toolTipFunction != null)
			{
				var text:String = toolTipFunction.call(this,axiisSprite.data);
				if(text != null && text != "")
				{
					tt = ToolTipManager.createToolTip(text,stage.mouseX + 10,stage.mouseY + 10);
					addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
				}
			}
		}
		
		public function onItemMouseOut(e:MouseEvent):void {
			var axiisSprite:AxiisSprite = e.target as AxiisSprite;
			if(!axiisSprite)
				return;
			
			if(tt)
			{
				ToolTipManager.destroyToolTip(tt);
				tt = null;
				removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			}	
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
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			if(tt)
			{
				tt.x = stage.mouseX + 10;
				tt.y = stage.mouseY + 10;
			}
		}
	}
}