package org.axiis.layouts
{
	import com.degrafa.geometry.Geometry;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.axiis.core.AbstractLayout;
	import org.axiis.core.ILayout;
	import org.axiis.core.ILayoutRepeater;

	public class BaseLayout extends AbstractLayout implements ILayout
	{
		public function BaseLayout()
		{
			super();
		}
		
		/**
		 * Set to TRUE - this will use a common bounds to fill all layout items being drawn
		 * Set to FALSE - each layout item will have its own fill bounds 
		 */
		[Inspectable]
		public var useCommonBounds:Boolean=false;
		
		private var _bounds:Rectangle;
		
		[Bindable(event="itemCountChange")]
		public function get itemCount():int
		{
			return _itemCount;
		}
		protected function set _itemCount(value:int):void
		{
			if(value != __itemCount)
			{
				__itemCount = value;
				dispatchEvent(new Event("itemCountChange"));
			}
		}
		protected function get _itemCount():int
		{
			return __itemCount;
		}
		private var __itemCount:int;
		
		private var _dataItems:Array;
		public function get dataItems():Array {
			return _dataItems;
		}
		
		[Bindable(event="currentLayoutChange")]
		public function get currentLayout():Geometry
		{
			return _currentLayout;
		}
		protected function set _currentLayout(value:Geometry):void
		{
			//We want this to fire each time so the geometry property changes propogate
			__currentLayout = value;
			dispatchEvent(new Event("currentLayoutChange"));
		}
		protected function get _currentLayout():Geometry
		{
			return __currentLayout;
		}
		
		private var __currentLayout:Geometry;
		
		[Bindable(event="dataProviderChange")]
		override public function set dataProvider(value:Object):void {
			super.dataProvider=value;
			_dataItems=new Array();
			for each(var o:Object in dataProvider)
			{
				_dataItems.push(o);
			}
			_itemCount=_dataItems.length;
		}
		
		
		
		override public function set layoutRepeater(value:ILayoutRepeater):void {
			super.layoutRepeater=value;
			
		}
		
		override public function render():void
		{
			if(!sprite || !_layoutRepeater)
				return;
			
			// The rectangle needed by degrafa to draw geometry if we want common bounds to all elements
			_bounds = new Rectangle(x,y,width,height);
			
			// Loop through the dataProvider, updating all the "current" properties
			// Call renderDatum at each iteration.
	
			_layoutRepeater.dataProvider=_dataItems;
			EventDispatcher(_layoutRepeater).addEventListener("currentIterationChange",onIteration);  //Hack, need to enforce correctly in interface
			_layoutRepeater.repeat();
			EventDispatcher(_layoutRepeater).removeEventListener("currentIterationChange",onIteration);  //Hack, need to enforce correctly in interface

		}
		
		protected function onIteration(e:Event):void {
			if (_layoutRepeater.currentIteration==-1) return;
			
			_currentIndex=_layoutRepeater.currentIteration;
			
			if(_currentIndex > sprite.numChildren - 1)
			{
				var newChildSprite:Sprite = new Sprite();
				sprite.addEventListener(MouseEvent.CLICK,handleSpriteClick);
				sprite.addChild(newChildSprite);
			}
			_currentItem = Sprite(sprite.getChildAt(_currentIndex));
			//_currentItem.width=this.width;
			//_currentItem.height=this.height;
			_currentDatum = dataItems[_currentIndex];
			_currentLayout=layoutRepeater.geometry;  //We are assuming only one geometry in the layout array - perhaps change interface to just one geometry
			renderDatum(_currentDatum,_currentItem,_bounds);
			
		}
		
		override public function renderDatum(datum:Object,targetSprite:Sprite,rectangle:Rectangle):void
		{
			targetSprite.graphics.clear();
			
			if(!geometries)
				return;

			for each(var geometry:Geometry in geometries)
			{
				//geometry.calculateLayout();
				geometry.preDraw();
				geometry.draw(targetSprite.graphics,(useCommonBounds) ? _bounds : geometry.commandStack.bounds);  
			}
		}
		
		protected function handleSpriteClick(event:MouseEvent):void
		{
			selectedItem = event.target as Sprite;
			selectedIndex = sprite.getChildIndex(selectedItem);
			selectedDatum = dataProvider[selectedIndex];
		}
		
		
	}
}