package org.axiis.core
{
	import com.degrafa.geometry.Geometry;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;

	public class LayoutRepeater extends EventDispatcher implements ILayoutRepeater
	{
		public function LayoutRepeater(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
		private var _dataProvider:Array;
		
		[Bindable(event="datumChange")]
		public function get currentDatum():Object
		{
			return _currentDatum;
		}
		protected function set _currentDatum(value:Object):void
		{
			if(value != __currentDatum)
			{
				__currentDatum = value;
				dispatchEvent(new Event("datumChange"));
			}
		}
		protected function get _currentDatum():Object
		{
			return __currentDatum;
		}
		private var __currentDatum:Object;
		
		public function set dataProvider(value:Array):void {
			_dataProvider=value;
		}
		
		public function get dataProvider():Array {
			return _dataProvider;
		}
		
		private var _modifiers:ArrayCollection;
		
		[Inspectable(category="General", arrayType="org.axiis.core.IRepeaterModifier")]
		[ArrayElementType("org.axiis.core.IRepeaterModifier")]
		public function get modifiers():Array{
			initModifiersCollection();
			return _modifiers.source;
		}
		public function set modifiers(value:Array):void{			
			initModifiersCollection();
			_modifiers.source = value;
		}
		
		/**
		* Initialize the collection by creating it and adding an event listener.
		**/
		private function initModifiersCollection():void{
			if(!_modifiers){
				_modifiers = new ArrayCollection();
				
				//add a listener to the collection
				
				//if(enableEvents){
				//	_modifiers.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
				//}
			}
		}
		
		[Bindable] 
		private var _geometry:Geometry;
		
		[Bindable]
		public function get geometry():Geometry {
			return _geometry;
		}
		public function set geometry(value:Geometry):void {
			_geometry=value;
		}
		
		
		
		[Bindable(event="currentIterationChange")]
		public function get currentIteration():int
		{
			return _currentIteration;
		}
		protected function set _currentIteration(value:int):void
		{
			if(value != __currentIteration)
			{
				__currentIteration = value;
				dispatchEvent(new Event("currentIterationChange"));
			}
		}
		protected function get _currentIteration():int
		{
			return __currentIteration;
		}
		private var __currentIteration:int;

		
		public function repeat():void {
			for (var i:int=0; i<dataProvider.length; i++) {
				_currentDatum=_dataProvider[i];
				
				if (_modifiers && _geometry) {
					for each (var modifier:IRepeaterModifier in _modifiers) { 
						if (i==0) modifier.beginModify(_geometry);
						modifier.apply();
					}
				}
				_currentIteration=i;
			}
			
			//End modifications (which returns the object to its original state
			if (_modifiers) {
				for each (modifier in _modifiers) {
					modifier.end();
				}
			}
			_currentIteration=-1;
		}
		
		
		
	}
}