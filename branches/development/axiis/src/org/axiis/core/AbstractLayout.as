package org.axiis.core
{
	import com.degrafa.geometry.Geometry;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	
	import org.axiis.DataCanvas;
	import org.axiis.layouts.GeometryRepeater;
	
	public class AbstractLayout  extends EventDispatcher implements ILayout
	{
		[Bindable]
		public var fills:Array = [];
		
		[Bindable]
		public var strokes:Array = [];
		
		[Bindable]
		public var palettes:Array = [];
		
		protected var _isRendering:Boolean=false;
		
		public function isRendering():Boolean {
			return _isRendering;
		}
		
		[Bindable]
		public function set visible(value:Boolean):void
		{
			_visible = value;
		}
		public function get visible():Boolean
		{
			return _visible;
		}
		private var _visible:Boolean=true;

		public function set emitDataTips(value:Boolean):void {
			_emitDataTips=value;
		}
		public function get emitDataTips():Boolean {
			return _emitDataTips;
		}
		private var _emitDataTips:Boolean = true;
		
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
		
		protected var _bounds:Rectangle;
		
				/***
		 * Store states collection
		 */
		public function set states(value:Array):void
		{
			if(_states != value)
			{
				_states=value;
				invalidate();
			}
		}
		public function get states():Array
		{
			return _states;
		}
		private var _states:Array = [];
		
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
		protected function set _dataItems(value:Array):void
		{
			if(value != __dataItems)
			{
				__dataItems = value;
				dispatchEvent(new Event("dataItemsChange"));
			}
		}
		protected function get _dataItems():Array
		{
			return __dataItems;
		}
		private var __dataItems:Array;
		
	
		[Bindable(event="dataProviderChange")]
		public function set dataProvider(value:Object):void
		{
			var t:Number=flash.utils.getTimer();
			if(_dataProvider != value)
			{
				_dataProvider = value;
				
				invalidateDataProvider();
				
				dispatchEvent(new Event("dataProviderChange"));
				
			}
		}
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		protected var _dataProvider:Object;
		
		public function invalidateDataProvider():void {
			
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
		}
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
		private var __currentValue:Object=0;
		
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
		protected var _dataField:String;
		
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
		protected var _labelField:String;
		
			
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
		protected var _x:Number=0;
		
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
		protected var _y:Number=0;
		
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
		protected var _width:Number=0;
		
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
		protected var _height:Number=0;
		
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
		
		
		public function get childSprites():Array
		{
			return _childSprites;
		}
		private var _childSprites:Array = [];


		public var name:String = "";
		
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
		
		public function AbstractLayout()
		{
		}
		
			//I hate to put yet another function in here, but I think we want a default data tip function
		private function dataTipFunction(data:Object):String
		{
			if(dataField && labelField && data[dataField] != null && data[labelField] != null)
			{
				return "<b>" + data[labelField] + "</b><br/>" + data[dataField];
			}
			return "";
		}
		
		/**
		 * This provides a way to further refine a layouts dataProvider by
		 * providing access to a custom filter data filter function. This allows
		 * developers to easily visualize subsets of the data without having to
		 * change the underlying data structure.
		 */
		public var dataFilterFunction:Function;
		
		public function get dataTipLabelFunction():Function
		{
			return _dataTipLabelFunction;
		}
		private var _dataTipLabelFunction:Function=dataTipFunction;
		
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
		protected var _referenceGeometryRepeater:GeometryRepeater=new GeometryRepeater();
		
	
		
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
		
		public function getSprite(owner:DataCanvas):Sprite
		{
			if(!sprite)
				sprite = new AxiisSprite();
			return sprite;
		}
		
		public function render(newSprite:AxiisSprite = null):void {
			//Meant to be overridden by concrete classes
		}
		
		private var _dataTipPositionFunction:Function;
		
		public function invalidate():void
		{
			dispatchEvent(new Event("layoutInvalidate"));
		} 
		
		[Bindable(event="renderingChange")]
		public function get rendering():Boolean
		{
			return _rendering;
		}
		public function set _rendering(value:Boolean):void
		{
			if(value != __rendering)
			{
				__rendering = value;
				dispatchEvent(new Event("renderingChange"));
			}
		}
		public function get _rendering():Boolean
		{
			return __rendering;
		}
		private var __rendering:Boolean = false;

	}
}