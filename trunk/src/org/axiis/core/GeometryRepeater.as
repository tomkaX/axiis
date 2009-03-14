package org.axiis.core
{
	import com.degrafa.geometry.Geometry;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;

	public class GeometryRepeater extends EventDispatcher implements IGeometryRepeater
	{
		public function GeometryRepeater(target:IEventDispatcher=null)
		{
			super(target);
		}
		
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
		
		[Bindable(event="dataProviderChange")]
		public function set dataProvider(value:Array):void
		{
			if(value != _dataProvider)
			{
				_dataProvider = value;
				dispatchEvent(new Event("dataProviderChange"));
			}
		}
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		private var _dataProvider:Array;
		
		[Inspectable(category="General", arrayType="org.axiis.core.IRepeaterModifier")]
		[ArrayElementType("org.axiis.core.IRepeaterModifier")]
		public function get modifiers():Array
		{
			initModifiersCollection();
			return _modifiers.source;
		}
		public function set modifiers(value:Array):void
		{			
			initModifiersCollection();
			_modifiers.source = value;
		}
		private var _modifiers:ArrayCollection;
		
		/**
		* Initialize the collection by creating it and adding an event listener.
		**/
		private function initModifiersCollection():void
		{
			if(!_modifiers)
			{
				_modifiers = new ArrayCollection();
				
				//add a listener to the collection
				
				//if(enableEvents){
				//	_modifiers.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
				//}
			}
		}
		
		[Bindable(event="geometryChange")]
		public function set geometry(value:Geometry):void
		{
			if(value != _geometry)
			{
				_geometry = value;
				dispatchEvent(new Event("geometryChange"));
			}
		}
		public function get geometry():Geometry
		{
			return _geometry;
		}
		private var _geometry:Geometry;
		
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

		
		public function repeat(iterationCallback:Function = null):void {
			if(dataProvider == null)
				return;
				
			for (var i:int=0; i<dataProvider.length; i++) {
				_currentDatum=_dataProvider[i];
				
				if (_modifiers && _geometry) {
					for each (var modifier:IRepeaterModifier in _modifiers) { 
						if (i==0) modifier.beginModify(_geometry);
						modifier.apply();
					}
				}
				
				_currentIteration=i;
				if(iterationCallback != null)
					iterationCallback.call(this);
			}
			
			//End modifications (which returns the object to its original state)
			if (_modifiers) {
				for each (modifier in _modifiers) {
					modifier.end();
				}
			}
			_currentIteration = -1;
		}
		
		public function applyIteration(iteration:int):void {
			for each (var modifier:IRepeaterModifier in _modifiers) { 
				modifier.applyCachedIteration(iteration);
			}
		}
	}
}