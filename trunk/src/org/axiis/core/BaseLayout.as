package org.axiis.core
{
	import com.degrafa.geometry.Geometry;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	
	import org.axiis.DataCanvas;
	import org.axiis.events.LayoutEvent;
	import org.axiis.events.StateChangeEvent;
	import org.axiis.states.State;
	
	[Event(name="invalidate", type="org.axiis.LayoutEvent")]
	
	public class BaseLayout extends EventDispatcher implements ILayout
	{
		public function BaseLayout()
		{
			super();
		}
		
		public var name:String = "";
		
		/**
		 * This provides a way to further refine a layouts dataProvider by providing access to a custom filter data filter function.
		 * this allows developers to easily visualize subsets of the data without having to change the underlying data structure.
		 */
		public var dataFilterFunction:Function;
		
		[Bindable(event="currentDataValueChange")]
		public function get currentDataValue():Object
		{
			/*
			if (owner.dataFunction!=null && dataField)
				return owner.dataFunction.call(this,_currentDatum[dataField],_currentDatum);
			else
				return _currentDataValue;
			*/
			return _currentDataValue;
		}
		protected function set _currentDataValue(value:Object):void
		{
			if(value != __currentDataValue)
			{
				__currentDataValue = value;
				dispatchEvent(new Event("currentDataValueChange"));
			}
		}
		protected function get _currentDataValue():Object
		{
			return __currentDataValue;
		}
		private var __currentDataValue:Object;
		
		
		[Bindable(event="currentLabelValueChange")]
		public function get currentLabelValue():String
		{
			if (owner.labelFunction !=null && labelField)
				return owner.labelFunction.call(this,_currentDatum[labelField],_currentDatum);
			else
				return _currentLabelValue;
		}
		protected function set _currentLabelValue(value:String):void
		{
			if(value != __currentLabelValue)
			{
				__currentLabelValue = value;
				dispatchEvent(new Event("currentLabelValueChange"));
			}
		}
		protected function get _currentLabelValue():String
		{
			return __currentLabelValue;
		}
		private var __currentLabelValue:String;
		
		/***
		 * Store states collection
		 */
		public function set states(value:Array):void
		{
			if(_states != value)
			{
				if(_states)
					removeListenersForStates(_states);
				_states=value;
				if(_states)
					addListenersForStates(_states);
				invalidate();
			}
		}
		public function get states():Array
		{
			return _states;
		}
		private var _states:Array;
		
		private var _activeStates:Array=new Array();

		/**
		 * Set to TRUE - this will use a common bounds to fill all layout items being drawn
		 * Set to FALSE - each layout item will have its own fill bounds 
		 */
		[Inspectable]
		public var scaleFill:Boolean=false;
		
		/**
		 * this will use the currentReference bounds of the the parentLayout is its own bounds, and set the currentItem (sprite) accordingly
		 */
		[Inspectable]
		public var useInheritedBounds:Boolean=true;
		
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
		public function get bounds():Bounds
		{
			return _bounds;
		}
		public function set bounds(value:Bounds):void
		{
			if(value != _bounds)
			{
				_bounds = value;
				dispatchEvent(new Event("boundsChange"));
			}
		}
		private var _bounds:Bounds;
		
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
		protected function set sprite(value:Sprite):void
		{
			if(value != _sprite)
			{
				_sprite = value;
				dispatchEvent(new Event("spriteChange"));
			}
		}
		protected function get sprite():Sprite
		{
			return _sprite;
		}
		private var _sprite:Sprite;

		[Bindable(event="dataProviderChange")]
		public function set dataProvider(value:Object):void
		{
			if(_dataProvider != value)
			{
				_dataProvider = value;
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
		public function set fills(value:Array):void
		{
			if(value != _fills)
			{
				_fills = value;
				dispatchEvent(new Event("geometryChange"));
			}
		}
		public function get fills():Array
		{
			return _fills;
		}
		private var _fills:Array;
		
		[Bindable(event="geometryChange")]
		public function set strokes(value:Array):void
		{
			if(value != _strokes)
			{
				_strokes = value;
				dispatchEvent(new Event("geometryChange"));
			}
		}
		public function get strokes():Array
		{
			return _strokes;
		}
		private var _strokes:Array;
		
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
				for each(var oldLayout:ILayout in layouts)
				{
					oldLayout.removeEventListener(StateChangeEvent.STATE_CHANGE,handleSubLayoutStateChange)
				}
				_layouts = value;
				for each(var newLayout:ILayout in layouts)
				{
					newLayout.addEventListener(StateChangeEvent.STATE_CHANGE,handleSubLayoutStateChange);
				}
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
		public function get currentItem():AxiisSprite
		{
			return _currentItem;
		}
		protected function set _currentItem(value:AxiisSprite):void
		{
			if(value != __currentItem)
			{
				__currentItem = value;
				dispatchEvent(new Event("currentItemChange"));
			}
		}
		protected function get _currentItem():AxiisSprite
		{
			return __currentItem;
		}
		private var __currentItem:AxiisSprite;
		
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
		
		public function measure():void
		{
		}
		
		public function render(newSprite:Sprite = null):void
		{
			var t:Number=flash.utils.getTimer();
			if(newSprite)
				this.sprite = newSprite;
				
			if(!sprite || !_referenceGeometryRepeater)
				return;			
			
			if (useInheritedBounds && parentLayout) {
				bounds=new Bounds(parentLayout.currentReference.x+(isNaN(x) ? 0:x),
									parentLayout.currentReference.y+(isNaN(y) ? 0:y),
									parentLayout.currentReference.width,
									parentLayout.currentReference.height);
			}
			else
			{
				bounds = new Bounds((isNaN(x) ? 0:x),(isNaN(y) ? 0:y),width,height);
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
			trace("BaseLayout.render() = " + (flash.utils.getTimer()-t) + " milliseconds");
		}
		
		protected function preIteration():void
		{
			
			_currentIndex++;
			_currentDatum = dataItems[_currentIndex];
			if (dataField)
				_currentDataValue = _currentDatum[dataField];
			else
				_currentDataValue=_currentDatum;
			if (labelField)
				_currentLabelValue = _currentDatum[labelField];

		}
		
		/**
		 * TODO we need to handle removing sprites when data is removed from the dataProvider
		 *  including removing listeneners so they can be garbage collected.
		 */
		protected function postIteration():void
		{

			_currentReference = referenceRepeater.geometry;
			
			// Add a new Sprite if there isn't one available on the display list.
			if(_currentIndex > sprite.numChildren - 1)
			{
				var newChildSprite:Sprite = new AxiisSprite();
				newChildSprite.doubleClickEnabled=true;
				newChildSprite.addEventListener(StateChangeEvent.STATE_CHANGE,handleSubLayoutStateChange);
				
				// Add listeners for all the state changing events
				for each(var state:State in states)
				{
					if(state.enterStateEvent != null)
						newChildSprite.addEventListener(state.enterStateEvent,onStateChange);
					if(state.exitStateEvent != null)
						newChildSprite.addEventListener(state.exitStateEvent,onStateChange);
				}
				
				sprite.addChild(newChildSprite);
			}
			_currentItem = AxiisSprite(sprite.getChildAt(_currentIndex));
			currentItem.data = currentDatum;
			
			
			drawGraphicsToChild(currentItem);
		}
		
		protected function drawGraphicsToChild(child:Sprite):void
		{
			var t:Number=flash.utils.getTimer();
			
			child.graphics.clear();
			
			if(!geometries)
				return;
			
			//Apply any states related to the sprite in question by altering the current geometry
			applyStates(child);
			
			for each(var geometry:Geometry in geometries)
			{
				if (geometry is IAxiisGeometry)
					IAxiisGeometry(geometry).parentLayout = this;
					
				geometry.preDraw();
				
				//We pass in different bounds depending on if we want all geoemtries filled by a common bounds or individually
				var drawingBounds:Rectangle = scaleFill
					? new Rectangle(_bounds.x+geometry.x, _bounds.y+geometry.y,_bounds.width,_bounds.height)
					: geometry.commandStack.bounds;
				
				geometry.draw(child.graphics,drawingBounds);
			}

	
			// Apply sublayouts for the targetSprite
			for each(var layout:ILayout in layouts)
			{
				/** TODO WE NEED TO HAVE A CLEAN UP ROUTINE ON DATAPROVIDER CHANGE **/
				layout.parentLayout = this;
				layout.render(currentItem);
			}
			
		
			//Remove any states from the geometry so the next iteration rendering is not affected.
			removeStates();
			
			trace("BaseLayout.drawGraphics() = " + (flash.utils.getTimer()-t) + " milliseconds");
		}
		
		private function addListenersForStates(states:Array):void
		{
			if(!sprite)
				return;
				
			var len:int = sprite.numChildren;
			for(var a:int = 0; a < len; a++)
			{
				var currSprite:Sprite = Sprite(sprite.getChildAt(a));
				for each(var state:State in states)
				{
					if(state.enterStateEvent != null)
						currSprite.addEventListener(state.enterStateEvent,onStateChange);
					if(state.exitStateEvent != null)
						currSprite.addEventListener(state.exitStateEvent,onStateChange);
				}
			}
		}
		
		private function removeListenersForStates(states:Array):void
		{
			if(!sprite)
				return;
			
			var len:int = sprite.numChildren;
			for(var a:int = 0; a < len; a++)
			{
				var currSprite:Sprite = Sprite(sprite.getChildAt(a));
				for each(var state:State in states)
				{
					if(state.enterStateEvent != null)
						currSprite.removeEventListener(state.enterStateEvent,onStateChange);
					if(state.exitStateEvent != null)
						currSprite.removeEventListener(state.exitStateEvent,onStateChange);
				}
			}
		}
		
		private function applyStates(sprite:Sprite):void {
			for (var y:int=0;y<_activeStates.length;y++) {
				if (_activeStates[y].target==sprite) {  
					_activeStates[y].state.apply();
				}
			}
		}
		
		private function removeStates():void {
			for (var y:int=0;y<_activeStates.length;y++) {
				_activeStates[y].state.remove();
			}
		}
		
		protected function onStateChange(event:Event):void
		{
			invalidateState(event);
			
			// Update the "current" properties
			_currentItem = AxiisSprite(event.target);
			
			var stateChangeEvent:StateChangeEvent = new StateChangeEvent(StateChangeEvent.STATE_CHANGE);
			_currentItem.dispatchEvent(stateChangeEvent);
			
			// Reset the current reference so things draw in the correct location during the next render
			_currentReference = null;
		}

		/**
		 * Each time a sprite has its state invalidated we re render the whole layout
		 * the alternative is figuring out a way for each iteration to keep track of its specific geometries (some type of cloning) and only rendering itself
		 * The current approach has a bigger CPU load, using stateful geometries for each iteration would have a bigger memory load
		 */
		private function invalidateState(event:Event):void {
			if (!states)
				return;
				
			var sprite:Sprite = Sprite(event.target);
			var eventType:String = event.type; 
				
			for (var i:int = 0; i < states.length; i++) {
				var state:State = states[i];
				if (state.enterStateEvent == eventType) {
					var stateObject:Object = new Object(); //quick hack to store these two variables in internal array, probably better to use a Dictionary.
					stateObject.target = sprite;
					stateObject.state = state;
					_activeStates.push(stateObject);
				}
			}	
			
			for (var y:int=0;y<_activeStates.length;y++) {
				if (_activeStates[y].state.exitStateEvent==eventType && _activeStates[y].target==sprite) {  //Remove state
					state.remove();
					_activeStates.splice(y,1);
				}
			}
		}
		
		private function handleSubLayoutStateChange(event:StateChangeEvent):void
		{
			if(parentLayout)
				event.addLayoutToChain(this);
			else
				renderChain(event.layoutChain,Sprite(event.target));
		}
		
		public function renderChain(chain:Array,targetSprite:Sprite):void
		{
			var parentSprite:Sprite = sprite.parent as Sprite;
			var ancestorOfTarget:Sprite = targetSprite;
			while(ancestorOfTarget != parentSprite)
			{
				_currentItem = sprite as AxiisSprite;
				sprite = ancestorOfTarget as Sprite;
				ancestorOfTarget = ancestorOfTarget.parent as Sprite;
			}
			_currentIndex = sprite.getChildIndex(currentItem);
			referenceRepeater.applyIteration(currentIndex);
			_currentReference = referenceRepeater.geometry;
			_currentDatum = dataItems[currentIndex];
			_currentDataValue = dataField
				? _currentDatum[dataField]
				: _currentDatum;
							
			if (labelField)
				_currentLabelValue = _currentDatum[labelField];
			
			if(chain.length == 0)
			{
				drawGraphicsToChild(currentItem);
			}
			else
			{
				var childLayout:ILayout = chain.pop() as ILayout;
				childLayout.renderChain(chain,targetSprite);
			}
		}
	}
}