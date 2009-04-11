package org.axiis.core
{
	import com.degrafa.core.ICloneable;
	import com.degrafa.geometry.Geometry;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	import org.axiis.DataCanvas;
	import org.axiis.events.LayoutEvent;
	import org.axiis.states.State;
	
	[Event(name="invalidate", type="org.axiis.LayoutEvent")]
	[Event(name="preRender", type="flash.events.Event")]
	[Event(name="itemPreDraw", type="flash.events.Event")]
	public class BaseLayout extends EventDispatcher implements ILayout
	{
		include "DrawingPlaceholders.as";
		
		public function BaseLayout()
		{
			super();
		}
		
		public function get childSprites():Array
		{
			return _childSprites;
		}
		private var _childSprites:Array = [];

		public function set emitDataTips(value:Boolean):void {
			_emitDataTips=value;
		}
		public function get emitDataTips():Boolean {
			return _emitDataTips;
		}
		private var _emitDataTips:Boolean = true;
		
		private var currentChild:AxiisSprite;
		
		private var activeStates:Array = [];
		
		public var name:String = "";
		
		/**
		 * This provides a way to further refine a layouts dataProvider by
		 * providing access to a custom filter data filter function. This allows
		 * developers to easily visualize subsets of the data without having to
		 * change the underlying data structure.
		 */
		public var dataFilterFunction:Function;
		
		//---------------------------------------------------------------------
		// "Current" properties
		//---------------------------------------------------------------------
		
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
		
		[Bindable(event="currentValueChange")]
		public function get currentValue():Object
		{
			/*
			if (owner.dataFunction!=null && dataField)
				return owner.dataFunction.call(this,_currentDatum[dataField],_currentDatum);
			else
				return _currentDataValue;
			*/
			return _currentValue;
		}
		protected function set _currentValue(value:Object):void
		{
			if(value != __currentValue)
			{
				__currentValue = value;
				dispatchEvent(new Event("currentValueChange"));
			}
		}
		protected function get _currentValue():Object
		{
			return __currentValue;
		}
		private var __currentValue:Object;
		
		[Bindable(event="currentLabelChange")]
		public function get currentLabel():String
		{
			if (owner.labelFunction !=null && labelField)
				return owner.labelFunction.call(this,_currentDatum[labelField],_currentDatum);
			else
				return _currentLabel;
		}
		protected function set _currentLabel(value:String):void
		{
			if(value != __currentLabel)
			{
				__currentLabel = value;
				dispatchEvent(new Event("currentLabelChange"));
			}
		}
		protected function get _currentLabel():String
		{
			return __currentLabel;
		}
		private var __currentLabel:String;

		[Bindable(event="dataTipLabelFunctionChange")]
		public function set dataTipLabelFunction(value:Function):void
		{
			if(value != _dataTipLabelFunction)
			{
				_dataTipLabelFunction = value;
				dispatchEvent(new Event("dataTipLabelFunctionChange"));
			}
		}
		public function get dataTipLabelFunction():Function
		{
			return _dataTipLabelFunction;
		}
		private var _dataTipLabelFunction:Function;
		
		[Bindable(event="dataTipPositionFunctionChange")]
		public function set dataTipPositionFunction(value:Function):void
		{
			if(value != _dataTipPositionFunction)
			{
				_dataTipPositionFunction = value;
				dispatchEvent(new Event("dataTipPositionFunctionChange"));
			}
		}
		public function get dataTipPositionFunction():Function
		{
			return _dataTipPositionFunction;
		}
		private var _dataTipPositionFunction:Function;
		
		/***
		 * Store states collection
		 */
		public function set states(value:Array):void
		{
			if(_states != value)
			{
				/* if(_states)
					removeListenersForStates(_states); */
				_states=value;
				/* if(_states)
					addListenersForStates(_states); */
				invalidate();
			}
		}
		public function get states():Array
		{
			return _states;
		}
		private var _states:Array = [];

		[Bindable(event="scaleFillChange")]
		/**
		 * Set to TRUE - this will use a common bounds to fill all layout items being drawn
		 * Set to FALSE - each layout item will have its own fill bounds 
		 */
		public function set scaleFill(value:Boolean):void
		{
			if(value != _scaleFill)
			{
				_scaleFill = value;
				invalidate();
				dispatchEvent(new Event("scaleFillChange"));
			}
		}
		public function get scaleFill():Boolean
		{
			return _scaleFill;
		}
		private var _scaleFill:Boolean;
		
		/**
		 * Not really sure what the intention of this was. It breaks the EmbedLayoutExample but has effect on the WedgeStack.
		 * Should we delete it?
		 */
		private var useInheritedBounds:Boolean = true;
		
		[Bindable]
		public function get parentLayout():ILayout
		{
			return _parentLayout;
		}
		public function set parentLayout(value:ILayout):void
		{
			_parentLayout=value;
		}
		private var _parentLayout:ILayout;

		[Bindable(event="boundsChange")]
		public function get bounds():Rectangle
		{
			return _bounds;
		}
		public function set bounds(value:Rectangle):void
		{
			if(value != _bounds)
			{
				_bounds = value;
				dispatchEvent(new Event("boundsChange"));
			}
		}
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
		
		
		[Bindable(event="dataItemsChange")]
		public function get dataItems():Array
		{
			return _dataItems;
		}
		private function set _dataItems(value:Array):void
		{
			if(value != __dataItems)
			{
				__dataItems = value;
				dispatchEvent(new Event("dataItemsChange"));
			}
		}
		private function get _dataItems():Array
		{
			return __dataItems;
		}
		private var __dataItems:Array;
		
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
		protected function set sprite(value:AxiisSprite):void
		{
			if(value != _sprite)
			{
				_sprite = value;
				dispatchEvent(new Event("spriteChange"));
			}
		}
		protected function get sprite():AxiisSprite
		{
			return _sprite;
		}
		private var _sprite:AxiisSprite;

		[Bindable(event="dataProviderChange")]
		public function set dataProvider(value:Object):void
		{
			if(_dataProvider != value)
			{
				_dataProvider = value;
				var oldLength:Number=(_dataItems) ? _dataItems.length : 0;
				_dataItems=new Array();
				if (dataProvider is ArrayCollection) {
					for (var i:int=0;i<dataProvider.source.length;i++) {
						if (dataFilterFunction != null) {
								if (dataFilterFunction.call(this,dataProvider.source[i])) {
									_dataItems.push(dataProvider.source[i]);
								}
							}
						else {
							_dataItems.push(dataProvider.source[i]);
						}
					}
				}
				else if (dataProvider is Array) {
					for (var j:int=0;j<dataProvider.length;j++) {
						if (dataFilterFunction != null) {
							if (dataFilterFunction.call(this,dataProvider[j])) {
								_dataItems.push(dataProvider[j]);
							}
						}
						else {
							_dataItems.push(dataProvider[j]);
						}
					}
				}
				else {
					for each(var o:Object in dataProvider)
					{
						if (dataFilterFunction != null) {
							if (dataFilterFunction.call(this,o)) {
								_dataItems.push(o);
							}
						}
						else {
							_dataItems.push(o);
						}
					}
				}
				
				_itemCount=_dataItems.length;
				
				if (oldLength > _dataItems.length)
					trimChildSprites(oldLength-_dataItems.length);
				
				dispatchEvent(new Event("dataProviderChange"));
			}
		}
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		private var _dataProvider:Object;
		
		[Inspectable(category="General")]
		[Bindable(event="referenceRepeaterChange")]
		public function set referenceRepeater(value:GeometryRepeater):void
		{
			if(value != _referenceGeometryRepeater)
			{
				_referenceGeometryRepeater = value;
				dispatchEvent(new Event("referenceRepeaterChange"));
			}
		}
		public function get referenceRepeater():GeometryRepeater
		{
			return _referenceGeometryRepeater;
		}
		protected var _referenceGeometryRepeater:GeometryRepeater;
		
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
		
		[Bindable(event="labelFieldChange")]
		public function set labelField(value:String):void
		{
			if(value != _labelField)
			{
				_labelField = value;
				dispatchEvent(new Event("labelFieldChange"));
			}
		}
		public function get labelField():String
		{
			return _labelField;
		}
		private var _labelField:String;
		
		[Bindable(event="geometryChange")]
		public function set drawingGeometries(value:Array):void
		{
			if(value != _geometries)
			{
				_geometries = value;
				dispatchEvent(new Event("geometryChange"));
			}
		}
		public function get drawingGeometries():Array
		{
			return _geometries;
		}
		private var _geometries:Array;
		
		[Bindable(event="layoutsChange")]
		public function set layouts(value:Array):void
		{
			if(value != _layouts)
			{
				/* for each(var oldLayout:ILayout in layouts)
				{
					oldLayout.removeEventListener(StateChangeEvent.STATE_CHANGE,onStateChange)
				} */
				_layouts = value;
				/* for each(var newLayout:ILayout in layouts)
				{
					newLayout.addEventListener(StateChangeEvent.STATE_CHANGE,onStateChange);
				} */
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
				invalidate();
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
				invalidate();
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
				invalidate();
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
				invalidate();
				dispatchEvent(new Event("heightChange"));
			}
		}
		public function get height():Number
		{
			return _height;
		}
		private var _height:Number;
		
		public function registerOwner(dataCanvas:DataCanvas):void
		{
			if(!owner)
			{
				owner = dataCanvas;
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
		protected var owner:DataCanvas;
		
		public function getSprite(owner:DataCanvas):Sprite
		{
			if(!sprite)
				sprite = new AxiisSprite();
			return sprite;
		}
		
		public function invalidate():void
		{
			dispatchEvent(new LayoutEvent(LayoutEvent.INVALIDATE,this as ILayout));
		}
		
		public function render(newSprite:AxiisSprite = null):void
		{
			//trace(name + " render " +currentIndex)
			var t:Number=flash.utils.getTimer();
			
			this.dispatchEvent(new Event("preRender"));
			
			if(newSprite)
				this.sprite = newSprite;
			
				
			if(!sprite || !_referenceGeometryRepeater)
				return;			
			
			if (useInheritedBounds && parentLayout)
			{
				bounds = new Rectangle(parentLayout.currentReference.x + (isNaN(x) ? 0 : x),
									parentLayout.currentReference.y + (isNaN(y) ? 0 : y),
									parentLayout.currentReference.width,
									parentLayout.currentReference.height);
			}
			else
			{
				bounds = new Rectangle((isNaN(x) ? 0:x),(isNaN(y) ? 0:y),width,height);
			}
			sprite.x = isNaN(_bounds.x) ? 0 :_bounds.x;
			sprite.y = isNaN(_bounds.y) ? 0 :_bounds.y;
			
			_referenceGeometryRepeater.dataProvider=_dataItems;
			if (_dataItems)
				_itemCount=_dataItems.length;
			
			if (_dataItems && _dataItems.length > 0)
			{
				_currentIndex=-1;
				_referenceGeometryRepeater.repeat(preIteration, postIteration);
			}
		}
		
		protected function preIteration():void
		{
			_currentIndex++;
			_currentDatum = dataItems[_currentIndex];
			if (dataField)
				_currentValue = _currentDatum[dataField];
			else
				_currentValue=_currentDatum;
			if (labelField)
				_currentLabel = _currentDatum[labelField];
		}
		
		/**
		 * TODO we need to handle removing sprites when data is removed from the dataProvider
		 *  including removing listeneners so they can be garbage collected.
		 */
		protected function postIteration():void
		{
			_currentReference = referenceRepeater.geometry;
			
			// Add a new Sprite if there isn't one available on the display list.
			if(_currentIndex > sprite.drawingSprites.length - 1)
			{
				var newChildSprite:AxiisSprite = createChildSprite();
				sprite.name = "drawing" + StringUtil.trim(name) + "" + sprite.drawingSprites.length;
				sprite.addDrawingSprite(newChildSprite);
				childSprites.push(newChildSprite);
			}
			currentChild = AxiisSprite(sprite.drawingSprites[currentIndex]);
			currentChild.data = currentDatum;
			
			dispatchEvent(new Event("itemPreDraw"));
			
			currentChild.bounds = bounds;
			currentChild.scaleFill = scaleFill;
			currentChild.geometries = cloneGeometries();
			currentChild.render();
			
			var i:int=0;
			for each(var layout:ILayout in layouts)
			{
				
				layout.parentLayout = this as ILayout;    //When we have multiple peer layouts the AxiisSprite needs to differentiate between child drawing sprites and child layout sprites
				if (currentChild.layoutSprites.length-1 < i) {
					var ns:AxiisSprite = createChildSprite();
					ns.name="layout - " + StringUtil.trim(name) + " " + currentChild.layoutSprites.length;
					currentChild.addLayoutSprite(ns);
				}
				layout.render(currentChild.layoutSprites[i]);
				i++;
			}
		}
		
		private function createChildSprite():AxiisSprite
		{
			var newChildSprite:AxiisSprite = new AxiisSprite();
			newChildSprite.doubleClickEnabled=true;
			newChildSprite.layout = this;
			newChildSprite.states = states;
			return newChildSprite;
		}
		
		private function cloneGeometries():Array
		{
			var toReturn:Array = new Array();
			for each(var geometry:Geometry in drawingGeometries)
			{
				if(geometry is ICloneable)
					toReturn.push(ICloneable(geometry).clone());
				else
					trace("error: geometry is not cloneable");
			}
			return toReturn;
		}
		
		private function trimChildSprites(trim:Number):void {
			if (!_sprite || _sprite.drawingSprites.length<trim) return;
			for (var i:int=0; i<=trim;i++) {
				var s:AxiisSprite=AxiisSprite(_sprite.removeChild(_sprite.drawingSprites[_sprite.drawingSprites.length-1]));
				s.dispose();
			}
		}
	}
}