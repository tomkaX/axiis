package org.axiis.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import org.axiis.events.LayoutEvent;
	
	[Event(name="invalidate", type="org.visml.LayoutEvent")]
	
	public class AbstractLayout extends EventDispatcher
	{
		public function AbstractLayout()
		{
			super();
		}
		
		/**
		 * The Sprite that will be added to the DataCanvas
		 */
		protected var sprite:Sprite;

		[Bindable(event="dataProviderChange")]
		public function set dataProvider(value:Object):void
		{
			if(value != _dataProvider)
			{
				_dataProvider = value;
				dispatchEvent(new Event("dataProviderChange"));
			}
		}
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		private var _dataProvider:Object;
		
		[Inspectable(category="General")]
		[Bindable(event="layoutRepeaterChange")]
		public function set layoutRepeater(value:ILayoutRepeater):void
		{
			if(value != _layoutRepeater)
			{
				_layoutRepeater = value;
				dispatchEvent(new Event("layoutRepeaterChange"));
			}
		}
		public function get layoutRepeater():ILayoutRepeater
		{
			return _layoutRepeater;
		}
		protected var _layoutRepeater:ILayoutRepeater;
		
		
		[Bindable(event="dataFieldChange")]
		public function set dataField(value:String):void
		{
			if(value != _dataField)
			{
				_dataField = value;
				dispatchEvent(new Event("dataFieldChange"));
			}
		}
		public function get dataField():String
		{
			return _dataField;
		}
		private var _dataField:String;
		
		[Bindable(event="geometryChange")]
		public function set geometries(value:Array):void
		{
			if(value != _geometries)
			{
				_geometries = value;
				dispatchEvent(new Event("geometryChange"));
			}
		}
		public function get geometries():Array
		{
			return _geometries;
		}
		private var _geometries:Array;
		
		[Bindable(event="layoutsChange")]
		public function set layouts(value:Array):void
		{
			if(value != _layouts)
			{
				_layouts = value;
				dispatchEvent(new Event("layoutsChange"));
			}
		}
		public function get layouts():Array
		{
			return _layouts;
		}
		private var _layouts:Array;
		
		[Bindable(event="xChange")]
		public function set x(value:Number):void
		{
			if(value != _x)
			{
				_x = value;
				dispatchEvent(new Event("xChange"));
			}
		}
		public function get x():Number
		{
			return _x;
		}
		private var _x:Number;
		
		[Bindable(event="yChange")]
		public function set y(value:Number):void
		{
			if(value != _y)
			{
				_y = value;
				dispatchEvent(new Event("yChange"));
			}
		}
		public function get y():Number
		{
			return _y;
		}
		private var _y:Number;
		
		[Bindable(event="widthChange")]
		public function set width(value:Number):void
		{
			if(value != _width)
			{
				_width = value;
				dispatchEvent(new Event("widthChange"));
			}
		}
		public function get width():Number
		{
			return _width;
		}
		private var _width:Number;
		
		[Bindable(event="heightChange")]
		public function set height(value:Number):void
		{
			if(value != _height)
			{
				_height = value;
				dispatchEvent(new Event("heightChange"));
			}
		}
		public function get height():Number
		{
			return _height;
		}
		private var _height:Number;
		
		[Bindable(event="scaleChange")]
		[Inspectable(category="General", enumeration="categorical,linear,log")]
		public function set scale(value:String):void
		{
			if(value != _scale)
			{
				_scale = value;
				dispatchEvent(new Event("scaleChange"));
			}
		}
		public function get scale():String
		{
			return _scale;
		}
		private var _scale:String;
		
		[Bindable(event="currentIndexChange")]
		public function get currentIndex():int
		{
			return _currentIndex;
		}
		protected function set _currentIndex(value:int):void
		{
			if(value != __currentIndex)
			{
				__currentIndex = value;
				dispatchEvent(new Event("currentIndexChange"));
			}
		}
		protected function get _currentIndex():int
		{
			return __currentIndex;
		}
		private var __currentIndex:int;
		
		[Bindable(event="currentItemChange")]
		public function get currentItem():Sprite
		{
			return _currentItem;
		}
		protected function set _currentItem(value:Sprite):void
		{
			if(value != __currentItem)
			{
				__currentItem = value;
				dispatchEvent(new Event("currentItemChange"));
			}
		}
		protected function get _currentItem():Sprite
		{
			return __currentItem;
		}
		private var __currentItem:Sprite;
		
		[Bindable(event="currentDatumChange")]
		public function get currentDatum():Object
		{
			return _currentDatum;
		}
		protected function set _currentDatum(value:Object):void
		{
			if(value != __currentDatum)
			{
				__currentDatum = value;
				dispatchEvent(new Event("currentDatumChange"));
			}
		}
		protected function get _currentDatum():Object
		{
			return __currentDatum;
		}
		private var __currentDatum:Object;
		
		[Bindable(event="selectedIndexChange")]
		public function set selectedIndex(value:int):void
		{
			if(value != _selectedIndex)
			{
				_selectedIndex = value;
				invalidate();
				dispatchEvent(new Event("selectedIndexChange"));
			}
		}
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		private var _selectedIndex:int = -1;
		
		[Bindable(event="selectedItemChange")]
		public function set selectedItem(value:Sprite):void
		{
			if(value != _selectedItem)
			{
				_selectedItem = value;
				invalidate();
				dispatchEvent(new Event("selectedItemChange"));
			}
		}
		public function get selectedItem():Sprite
		{
			return _selectedItem;
		}
		private var _selectedItem:Sprite;
		
		[Bindable(event="selectedDatumChange")]
		public function set selectedDatum(value:Object):void
		{
			if(value != _selectedDatum)
			{
				_selectedDatum = value;
				invalidate();
				dispatchEvent(new Event("selectedDatumChange"));
			}
		}
		public function get selectedDatum():Object
		{
			return _selectedDatum;
		}
		private var _selectedDatum:Object;
		
		public function registerOwner(displayObject:DisplayObject):void
		{
			if(!owner)
				owner = displayObject;
			else
				throw new Error("Layout already has an owner.");
		}
		protected var owner:DisplayObject;
		
		public function getSprite(owner:DisplayObject):Sprite
		{
			if(!sprite)
				sprite = new Sprite();
			return sprite;
		}
		
		public function initialize():void
		{
		}
		
		public function initializeGeometry():void
		{
		}
		
		public function invalidate():void
		{
			dispatchEvent(new LayoutEvent(LayoutEvent.INVALIDATE,this as ILayout));
		}
		
		public function measure():void
		{
		}
		
		public function render():void
		{
		}
		
		public function renderDatum(datum:Object,targetSprite:Sprite,rectange:Rectangle):void
		{
		}
	}
}