package org.axiis.core
{
	import com.degrafa.geometry.Geometry;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.axiis.events.LayoutEvent;
	
	[Event(name="invalidate", type="org.visml.LayoutEvent")]
	
	public class AbstractLayout extends EventDispatcher implements ILayout
	{
		public var name:String = "";
		
		public function AbstractLayout()
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
		
		
		public function get dataItems():Array
		{
			return _dataItems;
		}
		private var _dataItems:Array;
		
		[Bindable(event="currentReferenceChange")]
		public function get currentReference():Geometry
		{
			return _currentReference;
		}
		protected function set _currentReference(value:Geometry):void
		{
			//We want this to fire each time so the geometry property changes propogate
			__currentReference = value;
			dispatchEvent(new Event("currentReferenceChange"));
		}
		protected function get _currentReference():Geometry
		{
			return __currentReference;
		}
		private var __currentReference:Geometry;
		
		/**
		 * The Sprite that will be added to the DataCanvas
		 */
		protected var sprite:Sprite;

		[Bindable(event="dataProviderChange")]
		public function set dataProvider(value:Object):void
		{
			if(_dataProvider != value)
			{
				_dataProvider = value;
				
				_dataItems=new Array();
				for each(var o:Object in dataProvider)
				{
					_dataItems.push(o);
				}
				_itemCount=_dataItems.length;
				
				dispatchEvent(new Event("dataProviderChange"));
			}
		}
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		private var _dataProvider:Object;
		
		[Inspectable(category="General")]
		[Bindable(event="referenceGeometryRepeaterChange")]
		public function set referenceRepeater(value:IGeometryRepeater):void
		{
			if(value != _referenceGeometryRepeater)
			{
				_referenceGeometryRepeater = value;
				dispatchEvent(new Event("referenceGeometryRepeaterChange"));
			}
		}
		public function get referenceRepeater():IGeometryRepeater
		{
			return _referenceGeometryRepeater;
		}
		protected var _referenceGeometryRepeater:IGeometryRepeater;
		
		
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
			{
				owner = displayObject;
				for each(var childLayout:ILayout in layouts)
				{
					childLayout.registerOwner(owner);
				}
			}
			else
			{
				throw new Error("Layout already has an owner.");
			}
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
			/*var mySprite:Sprite = getSprite(owner);
			for each(var childLayout:ILayout in layouts)
			{
				childLayout.initializeGeometry();
				var childSprite:Sprite = childLayout.getSprite(owner);
				mySprite.addChild(childSprite);
			}*/
		}
		
		public function invalidate():void
		{
			dispatchEvent(new LayoutEvent(LayoutEvent.INVALIDATE,this as ILayout));
		}
		
		public function measure():void
		{
		}
		
		public function render(newSprite:Sprite = null):void
		{
			if(newSprite)
			{
				this.sprite = newSprite;
			}
			if(!sprite || !_referenceGeometryRepeater)
				return;
			
			// The rectangle needed by degrafa to draw geometry if we want common bounds to all elements
			_bounds = new Rectangle(x,y,width,height);
			
			_referenceGeometryRepeater.dataProvider=_dataItems;
			_referenceGeometryRepeater.repeat(onIteration);
		}
		
		protected function onIteration():void
		{
			_currentIndex = _referenceGeometryRepeater.currentIteration;
			
			if(_currentIndex > sprite.numChildren - 1)
			{
				var newChildSprite:Sprite = new Sprite();
				sprite.addEventListener(MouseEvent.CLICK,handleSpriteClick);
				sprite.addChild(newChildSprite);
			}
			_currentItem = Sprite(sprite.getChildAt(_currentIndex));
			_currentDatum = dataItems[_currentIndex];
			_currentReference = referenceRepeater.geometry;
			
			renderDatum(_currentDatum,_currentItem,_bounds);
			
			for each(var layout:ILayout in layouts)
			{
				layout.render(_currentItem);
			}
		}
		
		public function renderDatum(datum:Object,targetSprite:Sprite,rectange:Rectangle):void
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
			try
			{
				selectedItem = event.target as Sprite;
				selectedIndex = sprite.getChildIndex(selectedItem);
				selectedDatum = dataProvider[selectedIndex];
			}
			catch(e:Error)
			{
				trace("embed selection isn't working yet");
			}
		}
	}
}