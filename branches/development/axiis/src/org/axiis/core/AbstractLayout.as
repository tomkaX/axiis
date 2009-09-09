///////////////////////////////////////////////////////////////////////////////
//	Copyright (c) 2009 Team Axiis
//
//	Permission is hereby granted, free of charge, to any person
//	obtaining a copy of this software and associated documentation
//	files (the "Software"), to deal in the Software without
//	restriction, including without limitation the rights to use,
//	copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following
//	conditions:
//
//	The above copyright notice and this permission notice shall be
//	included in all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//	OTHER DEALINGS IN THE SOFTWARE.
///////////////////////////////////////////////////////////////////////////////
package org.axiis.core
{
	import com.degrafa.geometry.Geometry;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.core.IFactory;
	
	import org.axiis.DataCanvas;
	import org.axiis.events.LayoutItemEvent;
	import org.axiis.layouts.utils.GeometryRepeater;
	import org.axiis.managers.AnchoredDataTipManager;
	import org.axiis.managers.IDataTipManager;
	import org.axiis.utils.ObjectUtils;
	
	/**
	 * Dispatched when an AxiisSprite is mousedOver.
	 */
	[Event(name="itemDataTip", type="flash.events.Event")]

	// TODO To keep this as abstract as possible, we could make this not officially implement the interface
	/**
	 * AbstractLayout is an base class that provides basic implementations or
	 * stubs of methods defined in the ILayout interface. It is up to th
	 * subclass to appropriately override these implementations.
	 */
	public class AbstractLayout extends EventDispatcher implements ILayout
	{
		/**
		 * Constructor.
		 */
		public function AbstractLayout()
		{
			super();
		}
		
		public function set dataTipManager(value:IDataTipManager):void {
			_dataTipManager=value;
		}

		public function get dataTipManager():IDataTipManager {
			return _dataTipManager;
		}		
		
		private var _dataTipManager:IDataTipManager=new AnchoredDataTipManager;
		
		[Bindable]
		/**
		 * A placeholder for fills used within this layout. Modifying
		 * this array will not have any effect on the rendering of the layout.
		 */
		public var fills:Array = [];
		
		[Bindable]
		/**
		 * A placeholder for strokes used within this layout. Modifying
		 * this array will not have any effect on the rendering of the layout.
		 */
		public var strokes:Array = [];
		
		[Bindable]
		/**
		 * A placeholder for palettes used within this layout. Modifying
		 * this array will not have any effect on the rendering of the layout.
		 */
		public var palettes:Array = [];
		
		// TODO We have "rendering" and "isRendering".  We need to remove one
		/**
		 * Indicates that this layout is currently running its render cycle.
		 */
		public function isRendering():Boolean {
			return _isRendering;
		}
		/**
		 * @private
		 */
		protected var _isRendering:Boolean=false;
		
		[Bindable]
		/**
		 * @copy ILayout#visible
		 */
		public function get visible():Boolean
		{
			return _visible;
		}
		public function set visible(value:Boolean):void
		{
			_visible = value;
		}
		private var _visible:Boolean=true;

		/**
		 * @copy ILayout#emitDataTips
		 */
		public function get emitDataTips():Boolean
		{
			return _emitDataTips;
		}
		public function set emitDataTips(value:Boolean):void
		{
			_emitDataTips=value;
		}
		private var _emitDataTips:Boolean = true;
		
		[Bindable]
		/**
		 * @copy ILayout#parentLayout
		 */
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
		/**
		 * @copy ILayout#bounds
		 */
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
		/**
		 * @private
		 */
		protected var _bounds:Rectangle;
		
		/**
		 * An array of states that should be applied to this layout.
		 * 
		 * <p>
		 * As Layouts create children, each child sets up listeners on
		 * itself for the Layout's states' <code>enterStateEvent</code> and
		 * <code>exitStateEvent</code> events. When those events are triggered, the
		 * relevant state's apply and remove methods are called, respectively. This
		 * is usually used to modify the <code>drawingGeometry</code> of the Layout.
		 * </p>
		 * 
		 * @see State
		 */
		public function get states():Array
		{
			return _states;
		}
		public function set states(value:Array):void
		{
			if(_states != value)
			{
				_states=value;
				invalidate();
			}
		}
		private var _states:Array = [];
		
		[Bindable(event="itemCountChange")]
		/**
		 * @copy ILayout#itemCount
		 */
		public function get itemCount():int
		{
			return _itemCount;
		}
		/**
		 * @private
		 */
		protected function set _itemCount(value:int):void
		{
			if(value != __itemCount)
			{
				__itemCount = value;
				dispatchEvent(new Event("itemCountChange"));
			}
		}
		/**
		 * @private
		 */
		protected function get _itemCount():int
		{
			return __itemCount;
		}
		private var __itemCount:int;
		
		
		[Bindable(event="dataItemsChange")]
		/**
		 * An array of objects extracted from the dataProvider.
		 */
		public function get dataItems():Array
		{
			return _dataItems;
		}
		/**
		 * @private
		 */
		protected function set _dataItems(value:Array):void
		{
			if(value != __dataItems)
			{
				__dataItems = value;
				dispatchEvent(new Event("dataItemsChange"));
			}
		}
		/**
		 * @private
		 */
		protected function get _dataItems():Array
		{
			return __dataItems;
		}
		private var __dataItems:Array;
		
		[Bindable(event="dataProviderChange")]
		/**
		 * @copy ILayout#dataProvider
		 */
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		public function set dataProvider(value:Object):void
		{
			var t:Number=flash.utils.getTimer();
			if(_dataProvider != value)
			{
				_dataProvider = value;
				
				invalidateDataProvider();
				invalidate();
				
				dispatchEvent(new Event("dataProviderChange"));
				
			}
		}
		// TODO this should be private
		/**
		 * @private
		 */
		protected var _dataProvider:Object;
		
		// TODO This should really be renamed. It *validates* the dataProvider more than it invalidates it. Perhaps we could use a method that returns the dataItems rather than setting them directly.
		/**
		 * Iterates over the items in the dataProvider and stores them in
		 * dataItems.
		 *
		 * <p>
		 * If the dataProvider is Array or ArrayCollection dataItems will contain
		 * each item. If dataProvider is an Object, dataItems will contain an
		 * the object's properties as they are exposed in a for..each loop.
		 * </p> 
		 */
		public function invalidateDataProvider():void
		{
			
			_dataItems=new Array();
			if (dataProvider is ArrayCollection) {
				for (var i:int=0;i<dataProvider.source.length;i++) {
					if (dataProvider.source[i]) {
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
			}
			else if (dataProvider is Array) {
				for (var j:int=0;j<dataProvider.length;j++) {
					if (dataProvider[j]) {
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
			}
			else {
				for each(var o:Object in dataProvider)
				{
					if (o) {
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
			}
			
			
			_itemCount=_dataItems.length;
		
		}
		//---------------------------------------------------------------------
		// "Current" properties
		//---------------------------------------------------------------------
		
		[Bindable(event="currentIndexChange")]
		/**
		 * @copy ILayout#currentIndex
		 */
		public function get currentIndex():int
		{
			return _currentIndex;
		}
		/**
		 * @private
		 */
		protected function set _currentIndex(value:int):void
		{
			//if(value != __currentIndex)
			{
				__currentIndex = value;
				dispatchEvent(new Event("currentIndexChange"));
			}
		}
		/**
		 * @private
		 */
		protected function get _currentIndex():int
		{
			return __currentIndex;
		}
		private var __currentIndex:int;
		
		[Bindable(event="currentDatumChange")]
		/**
		 * @copy ILayout#currentDatum
		 */
		public function get currentDatum():Object
		{
			return _currentDatum;
		}
		/**
		 * @private
		 */
		protected function set _currentDatum(value:Object):void
		{
			//if(value != __currentDatum)
			{
				__currentDatum = value;
				dispatchEvent(new Event("currentDatumChange"));
			}
		}
		/**
		 * @private
		 */
		protected function get _currentDatum():Object
		{
			return __currentDatum;
		}
		private var __currentDatum:Object;
		
		[Bindable(event="currentValueChange")]
		/**
		 * @copy ILayout#currentValue
		 */
		public function get currentValue():Object
		{
			return _currentValue;
		}
		/**
		 * @private
		 */
		protected function set _currentValue(value:Object):void
		{
			//if(value != __currentValue)
			{
				__currentValue = value;
				dispatchEvent(new Event("currentValueChange"));
			}
		}
		/**
		 * @private
		 */
		protected function get _currentValue():Object
		{
			return __currentValue;
		}
		private var __currentValue:Object=0;
		
		[Bindable(event="currentLabelChange")]
		// TODO the label function should be applied somewhere other than the getter
		/**
		 * @copy ILayout#currentLabel
		 */
		public function get currentLabel():String
		{
			if (owner && owner.labelFunction != null && labelField)
				return owner.labelFunction.call(this,_currentDatum[labelField],_currentDatum);
			else
				return _currentLabel;
		}
		/**
		 * @private
		 */
		protected function set _currentLabel(value:String):void
		{
			//if(value != __currentLabel)
			{
				__currentLabel = value;
				dispatchEvent(new Event("currentLabelChange"));
			}
		}
		/**
		 * @private
		 */
		protected function get _currentLabel():String
		{
			return __currentLabel;
		}
		private var __currentLabel:String;
		
		[Bindable(event="currentReferenceChange")]
		/**
		 * @copy ILayout#currentReference
		 */
		public function get currentReference():Geometry  
		{
			return _currentReference;
		}
		/**
		 * @private
		 */
		protected function set _currentReference(value:Geometry):void
		{
			//We want this to fire each time so the geometry property changes propogate
			__currentReference = value;
			dispatchEvent(new Event("currentReferenceChange"));
		}
		/**
		 * @private
		 */
		protected function get _currentReference():Geometry
		{
			return __currentReference;
		}
		private var __currentReference:Geometry;
		
		
		[Bindable(event="dataFieldChange")]
		/**
		 * @copy ILayout#dataField
		 */
		public function get dataField():Object
		{
			return _dataField;
		}
		public function set dataField(value:Object):void
		{
			if(value != _dataField)
			{
				_dataField = value;
				dispatchEvent(new Event("dataFieldChange"));
			}
		}
		// TODO this should be private
		/**
		 * @private
		 */
		protected var _dataField:Object;
		
		[Bindable(event="labelFieldChange")]
		/**
		 * @copy ILayout#labelField
		 */
		public function get labelField():Object
		{
			return _labelField;
		}
		public function set labelField(value:Object):void
		{
			if(value != _labelField)
			{
				_labelField = value;
				dispatchEvent(new Event("labelFieldChange"));
			}
		}
		// TODO This should be private
		/**
		 * @private
		 */
		protected var _labelField:Object;
		
			
		[Bindable(event="xChange")]
		/**
		 * @copy ILayout#x
		 */
		public function get x():Number
		{
			return _x;
		}
		public function set x(value:Number):void
		{
			if(value != _x)
			{
				_x = value;
				invalidate();
				dispatchEvent(new Event("xChange"));
			}
		}
		private var _x:Number=0;
		
		[Bindable(event="yChange")]
		/**
		 * @copy ILayout#y
		 */
		public function get y():Number
		{
			return _y;
		}
		public function set y(value:Number):void
		{
			if(value != _y)
			{
				_y = value;
				invalidate();
				dispatchEvent(new Event("yChange"));
			}
		}
		private var _y:Number=0;
		
		[Bindable(event="widthChange")]
		/**
		 * @copy ILayout#width
		 */
		public function get width():Number
		{
			return _width;
		}
		public function set width(value:Number):void
		{
			if(value != _width)
			{
				_width = value;
				invalidate();
				dispatchEvent(new Event("widthChange"));
			}
		}
		private var _width:Number=0;
		
		[Bindable(event="heightChange")]
		/**
		 * @copy ILayout#height
		 */
		public function get height():Number
		{
			return _height;
		}
		public function set height(value:Number):void
		{
			if(value != _height)
			{
				_height = value;
				invalidate();
				dispatchEvent(new Event("heightChange"));
			}
		}
		private var _height:Number=0;
		
		/**
		 * Registers a DisplayObject as the owner of this ILayout.
		 * Throws an error if the ILayout already has an owner.
		 */
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
		/**
		 * @private
		 */
		protected var owner:DataCanvas;
		
		/**
		 * @copy ILayout#childSprites
		 */
		public function get childSprites():Array
		{
			return _childSprites;
		}
		private var _childSprites:Array = [];
		
		// TODO we can cut this
		/**
		 * A string used to identify this layout.
		 */
		public var name:String = "";
		
		[Bindable(event="layoutsChange")]
		/**
		 * @copy ILayout#layouts
		 */
		public function get layouts():Array
		{
			return _layouts;
		}
		public function set layouts(value:Array):void
		{
			if(value != _layouts)
			{

				for each(var layout:ILayout in _layouts) {
					layout.removeEventListener("itemDataTip",onItemDataTip);
				}
				
				_layouts = value;
				
				for each(layout in _layouts) {
					if (layout.emitDataTips)
						layout.addEventListener("itemDataTip",onItemDataTip);
				}
				
				
				dispatchEvent(new Event("layoutsChange"));
			}
		}
		private var _layouts:Array = [];
		
		//I hate to put yet another function in here, but I think we want a default data tip function
		private function dataTipFunction(axiisSprite:AxiisSprite):String
		{
			if(dataField && labelField)
			{
				return "<b>" + String(getProperty(axiisSprite.data,labelField)) + "</b><br/>" + String(getProperty(axiisSprite.data,dataField));
			}
			return "";
		}
		
		// TODO This should be cut. DataSet should manage the data.
		
		// I disagree, from a developer workflow this is very convienent - your filters are almost unique to visulization and
		// even though this deviates from OO best practices I think it is a good approach if we always assume we will be processing
		// an array or collection -  tg 8/7/09 
		/**
		 * This provides a way to further refine a layouts dataProvider by
		 * providing access to a custom filter data filter function. This allows
		 * developers to easily visualize subsets of the data without having to
		 * change the underlying data structure.
		 */
		public var dataFilterFunction:Function;
		
		[Bindable(event="dataTipLabelFunctionChange")]
		/**
		 * @copy ILayout#dataTipLabelFunction
		 */
		public function get dataTipLabelFunction():Function
		{
			return _dataTipLabelFunction;
		}
		public function set dataTipLabelFunction(value:Function):void
		{
			if(value != _dataTipLabelFunction)
			{
				_dataTipLabelFunction = value;
				dispatchEvent(new Event("dataTipLabelFunctionChange"));
			}
		}
		private var _dataTipLabelFunction:Function=dataTipFunction;
		
		[Bindable(event="dataTipPositionFunctionChange")]
		/**
		 * @copy ILayout#dataTipLabelFunction
		 */
		public function get dataTipPositionFunction():Function
		{
			return _dataTipPositionFunction;
		}
		public function set dataTipPositionFunction(value:Function):void
		{
			if(value != _dataTipPositionFunction)
			{
				_dataTipPositionFunction = value;
				dispatchEvent(new Event("dataTipPositionFunctionChange"));
			}
		}
		private var _dataTipPositionFunction:Function;
		
		[Inspectable(category="General")]
		[Bindable(event="referenceRepeaterChange")]
		/**
		 * @copy ILayout#referenceRepeater
		 */
		public function get referenceRepeater():GeometryRepeater
		{
			return _referenceGeometryRepeater;
		}
		public function set referenceRepeater(value:GeometryRepeater):void
		{
			if(value != _referenceGeometryRepeater)
			{
				_referenceGeometryRepeater = value;
				dispatchEvent(new Event("referenceRepeaterChange"));
			}
		}
		// TODO This should be private
		/**
		 * @private
		 */
		protected var _referenceGeometryRepeater:GeometryRepeater=new GeometryRepeater();
	
		[Bindable(event="geometryChange")]
		/**
		 * @copy ILayout#drawingGeometries
		 */
		public function get drawingGeometries():Array
		{
			return _geometries;
		}
		public function set drawingGeometries(value:Array):void
		{
			if(value != _geometries)
			{
				_geometries = value;
				dispatchEvent(new Event("geometryChange"));
			}
		}
		private var _geometries:Array;
		
		// TODO We have this property sprite, getSprite(), and render(sprite = null). We should use a single method to manipulating the sprite
		/**
		 * The sprite this layout is currently rendering to.
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
		
		/**
		 * @copy ILayout#getSprite
		 */
		public function getSprite(owner:DataCanvas):Sprite
		{
			if(!sprite)
				sprite = new AxiisSprite();
			return sprite;
		}
		
		/** 
		 * Draws this layout to the specified AxiisSprite.
		 * 
		 * @param sprite The AxiisSprite this layout should render to.
		 */
		public function render(newSprite:AxiisSprite = null):void {
			//Meant to be overridden by concrete classes
		}
		
		// TODO this should be in ILayout
		/**
		 * Notifies the DataCanvas that this layout needs to be rendered. 
		 */
		public function invalidate():void
		{
			this.dataTipManager.destroyAllDataTips();
			dispatchEvent(new Event("layoutInvalidate"));
			
		} 
		
		[Bindable(event="renderingChange")]
		/**
		 * @copy ILayout#rendering 
		 */
		public function get rendering():Boolean
		{
			return _rendering;
		}
		/**
		 * @private
		 */
		protected function set _rendering(value:Boolean):void
		{
			if(value != __rendering)
			{
				__rendering = value;
				dispatchEvent(new Event("renderingChange"));
			}
		}
		/**
		 * @private
		 */
		protected function get _rendering():Boolean
		{
			return __rendering;
		}
		private var __rendering:Boolean = false;
		
		[Bindable(event="dataTipAnchorPointChange")]
		/**
		 * TODO Document dataTipAnchorPoint
		 * Assumes ANY object with an x and y value :)
		 */
		public function get dataTipAnchorPoint():Object
		{
			return _dataTipAnchorPoint;
		}
		public function set dataTipAnchorPoint(value:Object):void
		{
			if(value != _dataTipAnchorPoint)
			{
				_dataTipAnchorPoint = value;
				invalidate();
				dispatchEvent(new Event("dataTipAnchorPointChange"));
			}
		}
		private var _dataTipAnchorPoint:Object;

		[Bindable(event="dataTipContentClassChange")]
		/**
		 * TODO Document dataTipContentClass
		 */
		public function get dataTipContentClass():IFactory
		{
			return _dataTipContentClass;
		}
		public function set dataTipContentClass(value:IFactory):void
		{
			if(value != _dataTipContentClass)
			{
				_dataTipContentClass = value;
				dispatchEvent(new Event("dataTipContentClassChange"));
			}
		}
		private var _dataTipContentClass:IFactory;
		
		//When a chid layout emits an event we want to bubble it
		private function onItemDataTip(e:LayoutItemEvent):void {
			this.dispatchEvent(new LayoutItemEvent("itemDataTip",e.item,e.sourceEvent));
		}
		
		public function getProperty(obj:Object,propertyName:Object):* { 
			return ObjectUtils.getProperty(this,obj,propertyName);
		}
		
		

	}
}