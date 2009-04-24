package org.axiis.core
{
	import com.degrafa.geometry.Geometry;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mx.core.FlexSprite;
	
	import org.axiis.states.State;

	public class AxiisSprite extends FlexSprite
	{
		public function AxiisSprite()
		{
			super();
		}
		
		public var revertingModifications:Array = [];
		
		private var activeStates:Array = [];
		
		private var eventListeners:Array = [];
		
		public var data:Object;
		
		public var layout:ILayout;
		
		public var bounds:Rectangle;
		
		public var geometries:Array = [];
		
		public var modifications:Array = [];
		
		public var scaleFill:Boolean = true;
		
		public function get layoutSprites():Array
		{
			return _layoutSprites;
		}
		private var _layoutSprites:Array=new Array();
		
		public function get drawingSprites():Array
		{
			return _drawingSprites;
		}
		private var _drawingSprites:Array=new Array();
		
		[Bindable(event="statesChange")]
		public function set states(value:Array):void
		{
			if(value != _states)
			{
				_states = value;
				
				// Add listeners for all the state changing events
				for each(var state:State in states)
				{
					if(state.enterStateEvent != null)
						addEventListener(state.enterStateEvent,onStateTriggeringEvent);
					if(state.exitStateEvent != null)
						addEventListener(state.exitStateEvent,onStateTriggeringEvent);
				}
				
				dispatchEvent(new Event("statesChange"));
			}
		}
		public function get states():Array
		{
			return _states;
		}
		private var _states:Array = [];
		
		public function addLayoutSprite(aSprite:AxiisSprite):void {
			if (!this.contains(aSprite)) {
				_layoutSprites.push(aSprite);
				addChild(aSprite);
			}
		}
		
		public function addDrawingSprite(aSprite:AxiisSprite):void {
			if (!this.contains(aSprite)) {
				_drawingSprites.push(aSprite);
				addChild(aSprite);
			}
		}
		
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
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			var obj:Object=new Object();
			obj.type=type;
			obj.listener=listener;
			obj.useCapture=useCapture;
			
			super.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			for (var i:int=0;i<eventListeners.length;i++) {
				if (eventListeners[i].type==type && eventListeners.listener==listener) {
					eventListeners.splice(i,1);
					i=eventListeners.length;
				}
			}
			super.removeEventListener(type,listener,useCapture);
		}
		
		public function dispose():void
		{
			while (numChildren > 0) {
				var s:AxiisSprite=this.getChildAt(0) as AxiisSprite;
				s.dispose();
				s.graphics.clear();
				this.removeChild(s);
			}
			
			graphics.clear();
			
			for each (var obj:Object in eventListeners)
			{
				super.removeEventListener(obj.type, obj.listener,obj.useCapture);
			}
		}
		
		public function render():void
		{
			graphics.clear();
			for each(var geometry:Geometry in geometries)
			{
				geometry.preDraw();
				
				var drawingBounds:Rectangle = scaleFill
						? new Rectangle(bounds.x+geometry.x, bounds.y+geometry.y,bounds.width,bounds.height)
						: geometry.commandStack.bounds;
				
				geometry.draw(graphics,drawingBounds);
			}
		}
				
		private function applyStates():void
		{
			for each(var activeState:State in activeStates)
			{
				for each(var geometry:Geometry in geometries)
				{
					activeState.apply(geometry);
				}
			}
		}
		
		private function removeStates():void
		{
			for each(var activeState:State in activeStates)
			{
				for each(var geometry:Geometry in geometries)
				{
					activeState.remove(geometry);
				}
			}
		}
		
		protected function onStateTriggeringEvent(event:Event):void
		{
			if(event.target != this)
				return;	
			
			updateActiveStates(event);
			setActiveStatesForAncestors(activeStates);
			setActiveStatesForDescendents(activeStates);
			//render();
		}
		
		protected function updateActiveStates(event:Event):void
		{
			var sprite:AxiisSprite = AxiisSprite(event.target);
			var eventType:String = event.type; 
			
			for (var i:int = 0; i < states.length; i++)
			{
				var state:State = State(states[i]);
				if(state.enterStateEvent == eventType)
				{
					activeStates.push(state);
				}
			}
			
			for(var a:int = 0; a < activeStates.length; a++)
			{
				var activeState:State = activeStates[a]
				if(activeState.exitStateEvent == eventType)
				{
					for each(var geometry:Geometry in geometries)
					{
						activeState.remove(geometry);
					}
					activeStates.splice(a,1);
				}
			}
		}
		
		protected function setActiveStatesForAncestors(stateTargets:Array):void
		{
			if(parent is AxiisSprite)
			{
				AxiisSprite(parent).activeStates = stateTargets;
				AxiisSprite(parent).setActiveStatesForAncestors(stateTargets);
				//AxiisSprite(parent).render();
			}
		}
		
		protected function setActiveStatesForDescendents(stateTargets:Array):void
		{
			for(var a:int = 0; a < numChildren; a++)
			{
				var currChild:DisplayObject = getChildAt(a);
				if(currChild is AxiisSprite)
				{
					AxiisSprite(currChild).activeStates = stateTargets;
					AxiisSprite(currChild).setActiveStatesForDescendents(stateTargets);
					//AxiisSprite(currChild).render();
				}
			}
		}
	}
}