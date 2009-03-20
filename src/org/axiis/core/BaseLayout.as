package org.axiis.core
{
	import com.degrafa.geometry.Geometry;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.axiis.DataCanvas;
	import org.axiis.events.LayoutEvent;
	import org.axiis.states.State;
	
	[Event(name="invalidate", type="org.axiis.LayoutEvent")]
	
	public class BaseLayout extends EventDispatcher implements ILayout
	{
		public var name:String = "";
		
		public function BaseLayout()
		{
			super();
		}
		
		
		[Bindable(event="currentDataValueChange")]
		public function get currentDataValue():Object
		{
			if (owner.dataFunction)
				return owner.dataFunction.call(this,_currentDatum[dataField],_currentDatum);
			else
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
			if (owner.labelFunction !=null)
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
		
		/**
		 * For child layouts we need to keep track of all their referenceRepeater propertyModifier cached valued.
		 * this is so if a state change occurs in a child the child can quickly access a specific iteration of propertymodifiers.
		 */
		public function get childLayoutCachedValues():Dictionary {
			return _childLayoutCachedValues;
		}
		
		private var _childLayoutCachedValues:Dictionary=new Dictionary();
		
		private var datumToSpriteHash:Dictionary = new Dictionary();
		
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
		
		private var stateChangingEventQueue:Array = [];
		
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
		
		/**
		 * This will apply its bounds to root level child geometries
		 */
		 [Inspectable]
		 public var autoApplyGeometryBounds:Boolean = true;
		
		
		[Bindable]
		public function get parentLayout():ILayout {
			return _parentLayout;
		}
		public function set parentLayout(value:ILayout):void {
			_parentLayout=value;
		}
		
		[Bindable]
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
				sprite = new Sprite();
			return sprite;
		}
		
		public function initialize():void
		{
		}
		
		public function invalidate():void
		{
			dispatchEvent(new LayoutEvent(LayoutEvent.INVALIDATE,this as ILayout));
		}
		
		public function measure():void
		{
		}
		
		//Used to store index for iterations
		private var _tempParentIndex:int;
		
		public function render(newSprite:Sprite = null, parentIndex:int=-1):void
		{
			if (layouts)
				_childLayoutCachedValues=new Dictionary();
				
			_tempParentIndex=parentIndex;
			
			if(newSprite)
			{
				this.sprite = newSprite;
			}
			if(!sprite || !_referenceGeometryRepeater)
				return;
			
			
			if (useInheritedBounds && parentLayout) {
				bounds=new Rectangle(parentLayout.currentReference.x+(isNaN(x) ? 0:x),
									parentLayout.currentReference.y+(isNaN(y) ? 0:y),
									parentLayout.currentReference.width,
									parentLayout.currentReference.height);
			}
			else {
				bounds = new Rectangle((isNaN(x) ? 0:x),(isNaN(y) ? 0:y),width,height);
			}

			sprite.x = isNaN(_bounds.x) ? 0 :_bounds.x;
			sprite.y = isNaN(_bounds.y) ? 0 :_bounds.y;
			
			_referenceGeometryRepeater.dataProvider=_dataItems;
			_itemCount=_dataItems.length;
			_referenceGeometryRepeater.repeat(onIteration);
		}
		
		/**
		 * TODO we need to handle removing sprites when data is removed from the dataProvider
		 *  including removing listeneners so they can be garbage collected.
		 */
		protected function onIteration():void
		{
			// Update the "current" properties
			_currentIndex = _referenceGeometryRepeater.currentIteration;
			_currentDatum = dataItems[_currentIndex];
			if (dataField) _currentDataValue = _currentDatum[dataField];
			if (labelField) _currentLabelValue = _currentDatum[labelField];
			_currentReference = referenceRepeater.geometry;
			
			
			// Add a new Sprite if there isn't one available on the display list.
			if(_currentIndex > sprite.numChildren - 1)
			{
				var newChildSprite:Sprite = new Sprite();
				newChildSprite.addEventListener(MouseEvent.CLICK,onSpriteMouseClick);
				newChildSprite.doubleClickEnabled=true;
				
				//We need to keep track of our parent layout index for single item rendering (i.e. states/tweens)
				newChildSprite.name=_tempParentIndex.toString();
				this.addDataCanvasListeners(newChildSprite);
				
				// Add listeners for all the state changing events
				for each(var state:State in states)
				{
					//trace("adding state listeners to " + newChildSprite.name);
					if(state.enterStateEvent != null)
						newChildSprite.addEventListener(state.enterStateEvent,onStateChange);
					if(state.exitStateEvent != null)
						newChildSprite.addEventListener(state.exitStateEvent,onStateChange);
				}
				
				sprite.addChild(newChildSprite);
			}
			_currentItem = Sprite(sprite.getChildAt(_currentIndex));
			Sprite(sprite.getChildAt(_currentIndex)).name=_tempParentIndex.toString();  //Stores our index releative to the parent
			datumToSpriteHash[_currentDatum] = _currentItem;
			
			renderDatum(_currentDatum,_currentItem);
		}
		
		protected function renderDatum(datum:Object,targetSprite:Sprite):void
		{
		
			targetSprite.graphics.clear();
			
			if(!geometries)
				return;
			
			//Apply any states related to the sprite in question by altering the current geometry
			applyStates(targetSprite);
			
			for each(var geometry:Geometry in geometries)
			{
				if (geometry is IAxiisGeometry)
					IAxiisGeometry(geometry).parentLayout = this;
					
				geometry.preDraw();
				
				//We pass in different bounds depending on if we want all geoemtries filled by a common bounds or individually
				var drawingBounds:Rectangle = scaleFill
					? new Rectangle(_bounds.x+geometry.x, _bounds.y+geometry.y,_bounds.width,_bounds.height)
					: geometry.commandStack.bounds;
					
				geometry.draw(targetSprite.graphics,drawingBounds);
			}
	
			// Apply sublayouts for the targetSprite
			for each(var layout:ILayout in layouts)
			{
				layout.parentLayout = this;
				layout.render(_currentItem,_currentIndex); //pass in our _currentIndex as parent
				if (!_childLayoutCachedValues[layout]) _childLayoutCachedValues[layout]=new Array();
				_childLayoutCachedValues[layout].push(layout.referenceRepeater.cachedValues);
			}
			
			//Remove any states from the geometry so the next iteration rendering is not affected.
			removeStates();
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
				//	trace("adding listeners to " + currSprite.name);
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
		
		protected function onSpriteMouseClick(event:MouseEvent):void
		{
			/*try
			{
				selectedItem = event.target as Sprite;
				selectedIndex = sprite.getChildIndex(selectedItem);
				selectedDatum = dataProvider[selectedIndex];
			}
			catch(e:Error)
			{
				trace("embed selection isn't working yet");
			}*/
		}
		
		public function applyIteration(iteration:int, parentIteration:int=-1):void {
			
			//If we have a parent layout we rely upon it to set the appropriate cached values
			if (parentLayout && parentIteration>=0) {
				parentLayout.applyIteration(parentIteration);    
				referenceRepeater.applyIteration(iteration,parentLayout.childLayoutCachedValues[this][parentIteration]);
			}
			
			//If we don't have a parent layout we apply our own iteration
			else {
				referenceRepeater.applyIteration(iteration);
			}
			
			_currentReference = referenceRepeater.geometry;
			_currentIndex=iteration;
			_currentDatum = dataItems[iteration];
			if (dataField) _currentDataValue = _currentDatum[dataField];
			if (labelField) _currentLabelValue = _currentDatum[labelField];

		}
		
		protected function onStateChange(event:Event):void
		{
			
			invalidateState(event);
			
			// Update the "current" properties
			_currentItem = Sprite(event.target);
			_currentIndex = _currentItem.parent.getChildIndex(_currentItem);
			
			applyIteration(_currentIndex,int(_currentItem.name));
			renderDatum(currentDatum,currentItem);
			
			// Reset the current reference so things draw in the correct location during the next render
			_currentReference = null;
		}
		
		/**
		 * These listeners will register all sprites for events that can be handled at the DataCanvas level
		 */
		protected function addDataCanvasListeners(newSprite:Sprite):void {
			newSprite.addEventListener(MouseEvent.CLICK,owner.onItemMouseClick);
			newSprite.addEventListener(MouseEvent.DOUBLE_CLICK,owner.onItemMouseDoubleClick);
			newSprite.addEventListener(MouseEvent.MOUSE_OVER,owner.onItemMouseOver);
			newSprite.addEventListener(MouseEvent.MOUSE_OUT,owner.onItemMouseOut);
			newSprite.addEventListener(MouseEvent.MOUSE_DOWN,owner.onItemMouseDown);
			newSprite.addEventListener(MouseEvent.MOUSE_UP,owner.onItemMouseUp);
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
	}
}