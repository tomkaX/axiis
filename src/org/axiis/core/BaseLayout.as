package org.axiis.core
{
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
	import org.axiis.events.StateChangeEvent;
	import org.axiis.states.State;
	
	[Event(name="invalidate", type="org.axiis.LayoutEvent")]
	[Event(name="itemPreDraw", type="flash.events.Event")]
	public class BaseLayout extends EventDispatcher implements ILayout
	{
		include "DrawingPlaceholders.as";
		
		public function BaseLayout()
		{
			super();
		}
		
		private var childSprites:Array = [];
		
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
		 * this will use the currentReference bounds of the the parentLayout is its own bounds, and set the currentItem (sprite) accordingly
		 */
		[Inspectable]
		public var useInheritedBounds:Boolean = true;
		
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
				for each(var oldLayout:ILayout in layouts)
				{
					oldLayout.removeEventListener(StateChangeEvent.STATE_CHANGE,onStateChange)
				}
				_layouts = value;
				for each(var newLayout:ILayout in layouts)
				{
					newLayout.addEventListener(StateChangeEvent.STATE_CHANGE,onStateChange);
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
		
		public function render(newSprite:Sprite = null):void
		{
			//trace(name + " render " +currentIndex)
			var t:Number=flash.utils.getTimer();
			if(newSprite)
				this.sprite = newSprite;
				
			if(!sprite || !_referenceGeometryRepeater)
				return;			
			
			if (useInheritedBounds && parentLayout)
			{
				bounds = new Bounds(parentLayout.currentReference.x + (isNaN(x) ? 0 : x),
									parentLayout.currentReference.y + (isNaN(y) ? 0 : y),
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
			if(_currentIndex > sprite.numChildren - 1)
			{
				var newChildSprite:Sprite = new AxiisSprite();
				newChildSprite.doubleClickEnabled=true;
				newChildSprite.addEventListener(StateChangeEvent.STATE_CHANGE,onStateChange);
				
				// Add listeners for all the state changing events
				for each(var state:State in states)
				{
					if(state.enterStateEvent != null)
						newChildSprite.addEventListener(state.enterStateEvent,onChildEvent);
					if(state.exitStateEvent != null)
						newChildSprite.addEventListener(state.exitStateEvent,onChildEvent);
				}
				sprite.name = StringUtil.trim(name) + "" + sprite.numChildren
				sprite.addChild(newChildSprite);
				childSprites.push(newChildSprite);
			}
			currentChild = AxiisSprite(sprite.getChildAt(currentIndex));
			currentChild.data = currentDatum;
			
			this.dispatchEvent(new Event("itemPreDraw"));
			
			drawGraphicsToChild(currentChild);
		}
		
		protected function drawGraphicsToChild(child:Sprite):void
		{
			var t:Number=flash.utils.getTimer();
			
			child.graphics.clear();
			
			if(!drawingGeometries)
				return;
			
			//Apply any states related to the sprite in question by altering the current geometry
			applyStates(child);
			
			for each(var geometry:Geometry in drawingGeometries)
			{
				if (geometry is IAxiisGeometry)
					IAxiisGeometry(geometry).parentLayout = this as ILayout;
					
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
				layout.parentLayout = this as ILayout;
				//layout.referenceRepeater.reset();
				layout.render(currentChild);
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
					if(state.enterStateEvent != null)
						currSprite.addEventListener(state.enterStateEvent,onChildEvent);
					if(state.exitStateEvent != null)
						currSprite.addEventListener(state.exitStateEvent,onChildEvent);
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
						currSprite.removeEventListener(state.enterStateEvent,onChildEvent);
					if(state.exitStateEvent != null)
						currSprite.removeEventListener(state.exitStateEvent,onChildEvent);
				}
			}
		}
		
		private function applyStates(sprite:Sprite):void
		{
			for (var y:int=0;y<activeStates.length;y++)
			{
				if (activeStates[y].target==sprite)  
					activeStates[y].state.apply();
			}
		}
		
		private function removeStates():void
		{
			for (var y:int=0;y<activeStates.length;y++)
			{
				activeStates[y].state.remove();
			}
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
					activeStates.push(stateObject);
				}
			}	
			
			for (var y:int=0;y<activeStates.length;y++) {
				if (activeStates[y].state.exitStateEvent==eventType && activeStates[y].target==sprite) {  //Remove state
					state.remove();
					activeStates.splice(y,1);
				}
			}
		}
		
		protected function onChildEvent(event:Event):void
		{
			//trace();
			//trace(name + " state change " + event.type + " " + event.target);
				
			if(childSprites.indexOf(event.target) == -1)
			{
				//trace("cancelled")
				_currentReference = null;
				_currentIndex = -1;
				referenceRepeater.reset();
				return;
			}
			
			invalidateState(event);
				
			// Update the "current" properties
			currentChild = AxiisSprite(event.target);
			
			var stateChangeEvent:StateChangeEvent = new StateChangeEvent(StateChangeEvent.STATE_CHANGE);
			currentChild.dispatchEvent(stateChangeEvent);
			
			// Reset the current reference so things draw in the correct location during the next render
			_currentReference = null;
			_currentIndex = -1;
			referenceRepeater.reset();
			
			//trace(referenceRepeater.geometry)
		}

		
		private function onStateChange(event:StateChangeEvent):void
		{
			//trace(name + " handleSubLayoutStateChange :: target " + event.target);
			//trace(name + " handleSubLayoutStateChange :: my sprite " + sprite);
			
			var doSubLayoutsHaveStates:Boolean = false;
			for each(var layout:BaseLayout in event.layoutChain)
			{
				if(layout.states.length != 0)
				{
					doSubLayoutsHaveStates = true;
					break;
				}
			}
			if(doSubLayoutsHaveStates || childSprites.indexOf(event.target) != -1)
			{
				if(parentLayout)
				{
					//trace("has parent -- adding to chain")
					event.addLayoutToChain(this as ILayout);
				}
				else
				{
					//trace("no parent -- rendering chain");
					renderChain(event.layoutChain,Sprite(event.target),Sprite(sprite.parent));
				}
			}
		}
		
		public function renderChain(chain:Array,targetSprite:Sprite,parentSprite:Sprite):void
		{
			//trace(name + " renderChain");
			//trace();
			var ancestorOfTarget:Sprite = targetSprite;
			//trace(name + " target " + ancestorOfTarget);
			while(ancestorOfTarget != parentSprite)
			{
				currentChild = sprite as AxiisSprite;
				sprite = ancestorOfTarget as Sprite;
				ancestorOfTarget = ancestorOfTarget.parent as Sprite;
				//trace(name + " ancestorOfTarget " + ancestorOfTarget);
			}
			_currentIndex = sprite.getChildIndex(currentChild);
			//trace(name,"currentIndex =",currentIndex);
			//trace(name,"currentItem =",currentChild);
			referenceRepeater.applyIteration(currentIndex);
			_currentReference = referenceRepeater.geometry;
			_currentDatum = dataItems[currentIndex];
			_currentValue = dataField
				? _currentDatum[dataField]
				: _currentDatum;
							
			if (labelField)
				_currentLabel = _currentDatum[labelField];
			
			if(chain.length == 0)
			{
				drawGraphicsToChild(currentChild);
				referenceRepeater.reset();
			}
			else
			{
				var childLayout:ILayout = chain.pop() as ILayout;
				childLayout.renderChain(chain,targetSprite,Sprite(currentChild.parent));
			}
		}
	}
}