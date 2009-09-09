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
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.*;
	
	import mx.core.FlexSprite;
	import mx.core.IFactory;
	
	import org.axiis.states.State;

	/**
	 * AxiisSprites render individual drawingGeometries from layouts.
	 */
	public class AxiisSprite extends FlexSprite
	{
		private static const DEFAULT_STATE:State = new State();
		
		/**
		 * Constructor.
		 */
		public function AxiisSprite()
		{
			super();
			//addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
		}
		
		private var eventListeners:Array = [];
		
		/**
		 * A hash which maps states to the sprites that reflect the rendered states.
		 */
		protected var stateToSpriteHash:Dictionary = new Dictionary();
		
		// TODO Document dataTipAnchorPoint
		public function get dataTipAnchorPoint():Point {
			if (_dataTipAnchorPoint)  {
				return _dataTipAnchorPoint;
			}
			else {
				return new Point(_maxBounds.width/2, _maxBounds.height/2);
			}
				
		}
		
		public function set dataTipAnchorPoint(value:Point):void {
			_dataTipAnchorPoint=value;
		}
		
		private var _dataTipAnchorPoint:Point;
		
		//Stores maximum bounds of all geometries
		private var _maxBounds:Rectangle;
		
		// TODO Document dataTipContentClass
		public var dataTipContentClass:IFactory;
		
		public var label:String;
		
		public var value:Object;
		
		public var index:int;
		
		/**
		 * The data that this AxiisSprite's geometries represent.
		 */
		public var data:Object;
		
		/**
		 * The layout that created and parents this AxiisSprite.
		 */
		public var layout:AbstractLayout;
		
		/**
		 * A rectangle representing the top-left corner and dimensions
		 * of the geometries this AxiisSprite renders.
		 */
		public var bounds:Rectangle;
		
		/**
		 * Whether or not the fills in this geometry should be scaled within the
		 * bounds rectangle.
		 */
		public var scaleFill:Boolean = true;
		
		/**
		 * The children of this AxiisSprite that act as the sprites for other
		 * layouts.
		 */
		public function get layoutSprites():Array
		{
			return _layoutSprites;
		}
		private var _layoutSprites:Array= [];
		
		/**
		 * The children of this AxiisSprite that act as the sprites that
		 * represent other data items from the layout's dataProvider.
		 */
		public function get drawingSprites():Array
		{
			return _drawingSprites;
		}
		private var _drawingSprites:Array= [];
		
		/**
		 * An array of states that should be activated or deactivated as the
		 * user interacts with this AxiisSprite.
		 *  
		 * @see State
		 */
		public function set states(value:Array):void
		{
			if(value != _states)
			{
				_states = value;
				
				// Add listeners for all the state changing events
				for each(var state:State in states)
				{
					if(state.enterStateEvent != null && state.enabled)
						addEventListener(state.enterStateEvent,handleStateTriggeringEvent);
					if(state.exitStateEvent != null  && state.enabled)
						addEventListener(state.exitStateEvent,handleStateTriggeringEvent);
				}
			}
		}
		public function get states():Array
		{
			return _states;
		}
		private var _states:Array = [];
		
		/**
		 * @private
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			var obj:Object=new Object();
			obj.type=type;
			obj.listener=listener;
			obj.useCapture=useCapture;
			
			super.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		/**
		 * @private
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			for (var i:int=0;i<eventListeners.length;i++) {
				if (eventListeners[i].type==type && eventListeners.listener==listener) {
					eventListeners.splice(i,1);
					i=eventListeners.length;
				}
			}
			super.removeEventListener(type,listener,useCapture);
		}
		
		/**
		 * Adds a AxiisSprite as one of the layoutSprites.
		 */
		public function addLayoutSprite(aSprite:AxiisSprite):void {
			if (!this.contains(aSprite)) {
				_layoutSprites.push(aSprite);
				addChild(aSprite);
			}
		}
		
		/**
		 * Adds a AxiisSprite as one of the drawingSprites.
		 */
		public function addDrawingSprite(aSprite:AxiisSprite):void {
			if (!this.contains(aSprite)) {
				_drawingSprites.push(aSprite);
				addChild(aSprite);
			}
		}
		
		/**
		 * @private
		 */
		override public function removeChild(child:DisplayObject):DisplayObject {
			for (var i:int=0;i<_layoutSprites.length;i++) {
				if (child==_layoutSprites[i]) {
					_layoutSprites.splice(i,1);
					continue;
				}
			}
			for (var j:int=0;j<_drawingSprites.length;j++) {
				if (child==_drawingSprites[j]) {
					_drawingSprites.splice(j,1);
					continue;
				}
			}
			if (child)
				super.removeChild(child);
			return child; 
		}
		
		/**
		 * Draws the specified geometries to a child of the AxiisSprite. The
		 * child is stored in a Dictionary keyed on the state passed in.
		 * 
		 * @ param geometries The geometries to store
		 * @ param state The state these geometries represent
		 */
		public function storeGeometries(geometries:Array,state:State = null):void
		{
			if(state == null)
				state = AxiisSprite.DEFAULT_STATE;
			var stateSprite:Sprite;
			if(stateToSpriteHash[state] == null)
			{
				stateSprite = new Sprite();
				stateToSpriteHash[state] = stateSprite;
				addChild(stateSprite);
			}
			stateSprite = stateToSpriteHash[state]
			stateSprite.graphics.clear();
			_maxBounds=new Rectangle();
			for each(var geometry:Geometry in geometries)
			{
				geometry.preDraw();
				var drawingBounds:Rectangle = scaleFill
					? new Rectangle(bounds.x+geometry.x, bounds.y+geometry.y,bounds.width,bounds.height)
					: geometry.commandStack.bounds;
				geometry.draw(stateSprite.graphics,drawingBounds);
				_maxBounds.width=Math.max(_maxBounds.width,drawingBounds.width+drawingBounds.x);
				_maxBounds.height=Math.max(_maxBounds.height,drawingBounds.height+drawingBounds.y);
				_maxBounds.x=Math.min(_maxBounds.x,drawingBounds.x);
				_maxBounds.y=Math.min(_maxBounds.y,drawingBounds.y);
			}
			
			//this.dataTipAnchorPoint=new Point(_maxBounds.x+_maxBounds.width/2,_maxBounds.y+_maxBounds.height/2);
		}

		/**
		 * Handler for any event from the states enterStateEvent.
		 * This begins the state change process and propagates
		 * state changes to the level specified by the state in question.
		 */
		protected function handleStateTriggeringEvent(event:Event):void
		{
			if(event.target.parent != this || layout.rendering)
				return;	
			
			var state:State = findStatesForEventType(event.type);
			var stateForChildren:State = state.propagateToDescendents ? state : DEFAULT_STATE;
			var stateForSiblings:State = state.propagateToSiblings ? state : DEFAULT_STATE;
			var stateForParents:State = state.propagateToAncestors ? state : DEFAULT_STATE;
			var statesForParentSiblings:State = state.propagateToAncestorsSiblings ? state : DEFAULT_STATE;
			
			activateStateForParents(stateForParents,statesForParentSiblings);			
			activateStateForSiblings(stateForSiblings);
			activateStateForChildren(stateForChildren);
			render(state);
		}
		
		/**
		 * Returns a state from the states array with the eventType as its enterStateEvent.
		 * If more than one state has the same event type, the one with at lowest index
		 * in the array is returned. If no state is found, the DEFAULT_STATE is returned.
		 * 
		 * @param eventType The event type to search for.
		 */
		protected function findStatesForEventType(eventType:String):State
		{
			for each(var state:State in states)
			{
				if(state.enterStateEvent == eventType)
					return state;
			}
			return DEFAULT_STATE;
		}
		
		/**
		 * Makes all descendents enter the state specfied.
		 * 
		 * @param state The state that the descendents should enter.
		 */
		protected function activateStateForChildren(state:State):void
		{	
			for(var a:int = 0; a < numChildren; a++)
			{
				var currChild:DisplayObject = getChildAt(a);
				if(currChild is AxiisSprite)
				{
					AxiisSprite(currChild).activateStateForChildren(state);
					AxiisSprite(currChild).render(state);
				}
			}
		}
		
		/**
		 * Makes all siblings (AxiisSprites with the same parent) enter the state specfied.
		 * 
		 * @param state The state that the siblings should enter.
		 */
		protected function activateStateForSiblings(state:State):void
		{
			for(var a:int = 0; a < parent.numChildren; a++)
			{
				var currChild:DisplayObject = parent.getChildAt(a);
				if(currChild != this && currChild is AxiisSprite)
				{
					AxiisSprite(currChild).render(state);
				}
			}
		}
		
		/**
		 * Makes all ancestores and their siblings enter the state specfied.
		 * 
		 * @param stateForAncestors The state that the ancestors should enter.
		 * @param stateForAncestorSiblings The state that the siblings of the ancestors should enter.
		 */
		protected function activateStateForParents(stateForAncestors:State,stateForAncestorSiblings:State):void
		{
 
			if(parent is AxiisSprite)
			{
				AxiisSprite(parent).activateStateForSiblings(stateForAncestorSiblings)
				AxiisSprite(parent).activateStateForParents(stateForAncestors,stateForAncestorSiblings);
				AxiisSprite(parent).render(stateForAncestors);
			}
		}
		
		/**
		 * Displays the child sprite for the state parameter and hides all others.
		 * If no state is provided, the default state is used instead.
		 * 
		 * @param state The state this AxiisSprite should show.
		 */
		public function render(state:State = null):void
		{
			if(state == null)
				state = AxiisSprite.DEFAULT_STATE;
		
			var childToDisplay:Sprite = stateToSpriteHash[state];
			for each(var stateChild:Sprite in stateToSpriteHash)
			{				
				if(stateChild == childToDisplay)
					stateChild.visible = true;
				else
					stateChild.visible = false;
			}
		}
		
		/**
		 * Prepares the AxiisSprite for garbage collection.
		 */
		public function dispose():void
		{
			graphics.clear();
			while (numChildren > 0)
			{
				var s:Sprite = Sprite(getChildAt(0));
				if(s is AxiisSprite)
					AxiisSprite(s).dispose();
				s.graphics.clear();
				removeChild(s);
			}
			for each (var obj:Object in eventListeners)
			{
				super.removeEventListener(obj.type, obj.listener,obj.useCapture);
			}
			states = null;
			stateToSpriteHash = null;
		}
		
	
		/*private function onMouseOver(e:Event):void {
			var tte:ToolTipEvent=new ToolTipEvent(ToolTipEvent.TOOL_TIP_SHOW);
			this.dispatchEvent(tte);
		}*/
	}
}