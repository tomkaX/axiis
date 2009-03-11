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
	import org.axiis.states.State;
	
	[Event(name="invalidate", type="org.axiis.LayoutEvent")]
	
	public class AbstractLayout extends EventDispatcher implements ILayout
	{
		public var name:String = "";
		
		public function AbstractLayout()
		{
			super();
		}
		
		/***
		 * Store states collection
		 */
		public function set states(value:Array):void {
			_states=value;
		}
		
		public function get states():Array {
			return _states;
		}
		
		private var _activeStates:Array=new Array();
		
		protected var _states:Array;

		
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
			
			
			if (useInheritedBounds && parentLayout) {
				bounds=new Rectangle(parentLayout.currentReference.x+(isNaN(x) ? 0:x),
									parentLayout.currentReference.y+(isNaN(y) ? 0:y),
									parentLayout.currentReference.width,
									parentLayout.currentReference.height);
			}
			else {
				bounds = new Rectangle((isNaN(x) ? 0:x),(isNaN(y) ? 0:y),width,height);
			}

			sprite.x=isNaN(_bounds.x) ? 0:_bounds.x;
			sprite.y=isNaN(_bounds.y) ? 0:_bounds.y;
	
			_referenceGeometryRepeater.dataProvider=_dataItems;
			_referenceGeometryRepeater.repeat(onIteration);
		}
		
		protected function onIteration():void
		{
			_currentIndex = _referenceGeometryRepeater.currentIteration;
			
			if(_currentIndex > sprite.numChildren - 1)
			{
				var newChildSprite:Sprite = new Sprite();
				sprite.addEventListener(MouseEvent.CLICK,onSpriteMouseClick);
				sprite.addEventListener(MouseEvent.MOUSE_MOVE,onSpriteMouseMove);
				sprite.addEventListener(MouseEvent.MOUSE_OVER,onSpriteMouseOver);
				sprite.addEventListener(MouseEvent.MOUSE_OUT,onSpriteMouseOut);
				sprite.addChild(newChildSprite);
			}
	
			_currentItem = Sprite(sprite.getChildAt(_currentIndex));
			_currentDatum = dataItems[_currentIndex];
			_currentReference = referenceRepeater.geometry;
			
			renderDatum(_currentDatum,_currentItem,_bounds);
			
			for each(var layout:ILayout in layouts)
			{
				layout.parentLayout=this;
				layout.render(_currentItem);
			}
		}
		
		public function renderDatum(datum:Object,targetSprite:Sprite,rectange:Rectangle):void
		{
			targetSprite.graphics.clear();
			
			if(!geometries)
				return;
			
			//Apply any states related to the sprite in question by altering the current geometry
			applyStates(targetSprite);
			
			for each(var geometry:Geometry in geometries)
			{
				if (geometry is IAxiisGeometry) IAxiisGeometry(geometry).parentLayout=this;
				geometry.preDraw();
				//We pass in different bounds depending on if we want all geoemtries filled by a common bounds or individually
				geometry.draw(targetSprite.graphics,(scaleFill) ? new Rectangle(_bounds.x+geometry.x, _bounds.y+geometry.y,_bounds.width,_bounds.height) : geometry.commandStack.bounds);
			}
			
			//Remove any states from the geometry so the next iteration rendering is not affected.
			removeStates();
		}
		
		private function applyStates(sprite:Sprite):void {
			//trace("current sprite " + sprite.name);
			
			for (var y:int=0;y<_activeStates.length;y++) {
			//	trace("target sprites " + _activeStates[y].target.name);
				if (_activeStates[y].target==sprite) {  
					_activeStates[y].state.apply();
				}
			}
		}
		
		private function removeStates():void {
			//trace("current sprite " + sprite.name);
			
			for (var y:int=0;y<_activeStates.length;y++) {
				_activeStates[y].state.remove();
			}
		}
		
		protected function onSpriteMouseClick(event:MouseEvent):void
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
		
		protected function onSpriteMouseOver(event:MouseEvent):void
		{
			invalidateState(Sprite(event.target),event.type);
		}
		
		protected function onSpriteMouseOut(event:MouseEvent):void
		{
			invalidateState(Sprite(event.target),event.type);
		}
		
		protected function onSpriteMouseMove(event:MouseEvent):void
		{
			 trace("mouse moving ..");
		}
		
		/**
		 * Each time a sprite has its state invalidated we re render the whole layout
		 * the alternative is figuring out a way for each iteration to keep track of its specific geometries (some type of cloning) and only rendering itself
		 * The current approach has a bigger CPU load, using stateful geometries for each iteration would have a bigger memory load
		 */
		private function invalidateState(sprite:Sprite, eventType:String ):void {
			//Look at all states and see if we have any mouse over
			trace("mouse out on " + sprite.name);
			if (!states) return;
			for (var i:int=0;i<states.length;i++) {
				var state:State=states[i];
				if (state.enterStateEvent==eventType) {
					var stateObject:Object=new Object(); //quick hack to store these two variables in internal array, probably better to use a Dictionary.
					stateObject.target=sprite;
					stateObject.state=state;
					_activeStates.push(stateObject);
				}
			}	
			
			for (var y:int=0;y<_activeStates.length;y++) {
				if (_activeStates[y].state.exitStateEvent==eventType && _activeStates[y].target==sprite) {  //Remove state
					state.remove();
					_activeStates.splice(y,1);	
				}
			}
			
			render();
			
		}
		
		
	}
}