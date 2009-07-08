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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.core.FlexSprite;
	import mx.core.UIComponent;
	import mx.events.ToolTipEvent;
	
	import org.axiis.states.State;

	// TODO We should have two class of AxiisSprites: LayoutSprites and DrawingSprites
	/**
	 * AxiisSprites render individual drawingGeometries from layouts.
	 */
	public class AxiisSprite extends FlexSprite
	{
		/**
		 * Constructor.
		 */
		public function AxiisSprite()
		{
			super(); var t:MouseEvent
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
		}
		
		private var eventListeners:Array = [];

		private var activeStates:Array = [];
		
		/**
		 * The data that this AxiisSprite's geometries represent.
		 */
		public var data:Object;
		
		/**
		 * The layout that created and parents this AxiisSprite.
		 */
		public var layout:ILayout;
		
		/**
		 * A rectangle representing the top-left corner and dimensions
		 * of the geometries this AxiisSprite renders.
		 */
		public var bounds:Rectangle;
		
		/**
		 * An array of geometries to render.
		 */
		public var geometries:Array = [];
		
		/**
		 * The PropertySetters that need to be applied in order to reset the 
		 * geometries back to the states they were in when the parenting layout
		 * last ran its render function.
		 */
		public var revertingModifications:Array = [];
		
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
					if(state.enterStateEvent != null)
						addEventListener(state.enterStateEvent,handleStateTriggeringEvent);
					if(state.exitStateEvent != null)
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
		
		// TODO Since BaseLayout interacts with the revertingModifications array directly, we don't really need this method.
		/**
		 * Empties the revertingModifications array.
		 */
		public function clearModifications():void
		{
			revertingModifications = [];
		}
	
		/**
		 * Handler for any event from the states enterStateEvent.
		 * This begins the state change process and propagates
		 * state changes to the level specified by the state in question.
		 */
		protected function handleStateTriggeringEvent(event:Event):void
		{
			if(event.target != this || this.layout.rendering)
				return;	
			
			activeStates = findStatesForEventType(event.type);
			
			var statesForChildren:Array = [];
			var statesForSiblings:Array = [];
			//var statesForSiblingChildren:Array = [];
			var statesForParents:Array = [];
			var statesForParentSiblings:Array = [];
			for each(var state:State in activeStates)
			{
				if(state.propagateToDescendents)
					statesForChildren.push(state);
				if(state.propagateToSiblings)
					statesForSiblings.push(state);
				//if(state.propagateToSiblingChildren)
				//	statesForSiblingChildren.push(state);
				if(state.propagateToAncestors)
					statesForParents.push(state);
				if(state.propagateToAncestorsSiblings)
					statesForParentSiblings.push(state);
			}
			
			setActiveStatesForParents(statesForParents,statesForParentSiblings);
			//setActiveStatesForSiblings(statesForSiblings,statesForSiblingChildren);
			setActiveStatesForSiblings(statesForSiblings);
			setActiveStatesForChildren(statesForChildren);
			render();
		}
		
		/**
		 * Returns an array of states that have eventType as their enterStateEvent.
		 * 
		 * @param eventType The event type to search for
		 */
		protected function findStatesForEventType(eventType:String):Array
		{
			var toReturn:Array = [];
			for each(var state:State in states)
			{
				if(state.enterStateEvent == eventType)
					toReturn.push(state);
			}
			return toReturn;
		}
		
		/**
		 * Makes all descendents enter the states specfied.
		 * 
		 * @param states The array of states that the descendents should enter.
		 */
		protected function setActiveStatesForChildren(states:Array):void
		{	
			for(var a:int = 0; a < numChildren; a++)
			{
				var currChild:DisplayObject = getChildAt(a);
				if(currChild is AxiisSprite)
				{
					AxiisSprite(currChild).activeStates = states;
					AxiisSprite(currChild).setActiveStatesForChildren(states);
					AxiisSprite(currChild).render();
				}
			}
		}
		
		/**
		 * Makes all siblings (AxiisSprites with the same parent) enter the
		 * states specfied.
		 * 
		 * @param states The array of states that the siblings should enter.
		 */
		protected function setActiveStatesForSiblings(statesForSiblings:Array):void
		{
			if(!parent)
				return;
			
			for(var a:int = 0; a < parent.numChildren; a++)
			{
				var currChild:DisplayObject = parent.getChildAt(a);
				if(currChild != this && currChild is AxiisSprite)
				{
					AxiisSprite(currChild).activeStates = statesForSiblings;
					//AxiisSprite(currChild).setActiveStatesForChildren(statesForSiblingChildren);
					AxiisSprite(currChild).render();
				}
			}
		}
		
		/**
		 * Makes all ancestores enter the states specfied.
		 * 
		 * @param states The array of states that the ancestors should enter.
		 */
		protected function setActiveStatesForParents(statesForAncestors:Array,statesForAncestorSiblings:Array):void
		{
			if(parent is AxiisSprite)
			{
				AxiisSprite(parent).activeStates = statesForAncestors;
				//AxiisSprite(parent).setActiveStatesForSiblings(statesForAncestorSiblings,[])
				AxiisSprite(parent).setActiveStatesForSiblings(statesForAncestorSiblings)
				AxiisSprite(parent).setActiveStatesForParents(statesForAncestors,statesForAncestorSiblings);
				AxiisSprite(parent).render();
			}
		}
		
		/**
		 * Draws the geometries to the AxiisSprites graphics context.
		 */
		public function render():void
		{
			//trace(this)
			for each(var modification:PropertySetter in revertingModifications)
			{
				//trace(modification.property,modification.value)
				modification.apply();
			}
			
			for each(var activeState:State in activeStates)
			{
				activeState.apply();
			}
			
			graphics.clear();
			for each(var geometry:Geometry in geometries)
			{
				geometry.preDraw();
				var drawingBounds:Rectangle = scaleFill
						? new Rectangle(bounds.x+geometry.x, bounds.y+geometry.y,bounds.width,bounds.height)
						: geometry.commandStack.bounds;
				geometry.draw(graphics,drawingBounds);
			}
			
			for each(activeState in activeStates)
			{
				activeState.remove();
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
				var s:AxiisSprite= getChildAt(0) as AxiisSprite;
				s.dispose();
				s.graphics.clear();
				removeChild(s);
			}
			
			for each (var obj:Object in eventListeners)
			{
				super.removeEventListener(obj.type, obj.listener,obj.useCapture);
			}
			states = null;
			revertingModifications = null;
		}
		
		private function onMouseOver(e:Event):void {
			var t:UIComponent
			var tte:ToolTipEvent=new ToolTipEvent(ToolTipEvent.TOOL_TIP_SHOW);
			this.dispatchEvent(tte);
		}
	}
}
