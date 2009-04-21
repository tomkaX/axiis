package org.axiis.core
{
	import com.degrafa.geometry.Geometry;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class GeometryRepeater extends EventDispatcher
	{
		public function GeometryRepeater()
		{
			super();
		}
		
		public var geometry:Geometry;
		
		[Inspectable(category="General", arrayType="org.axiis.core.PropertyModifier")]
		[ArrayElementType("org.axiis.core.PropertyModifier")]
		public var modifiers:Array;
		
		public var dataProvider:Array;
		
		public function get currentDatum():Object
		{
			return _currentDatum;
		}
		private var _currentDatum:Object;
		
		public function get currentIteration():int
		{
			return _currentIteration;
		}
		private var _currentIteration:int;
		
		public function repeat(preIterationCallback:Function = null, postIterationCallback:Function=null):void
		{
			if(!dataProvider)
				return;
				
			_currentIteration = 0;
			
			var len:int = dataProvider.length;
			for (var i:int = 0; i < len; i++)
			{
				if(preIterationCallback != null)
					preIterationCallback.call(this);
				
				_currentDatum = dataProvider[i];
				
				if(geometry)
				{
					for each (var modifier:PropertyModifier in modifiers)
					{ 
						if(i == 0)
							modifier.beginModify(geometry);
						modifier.apply();
					}
				}
				_currentIteration = i;
				
				if(postIterationCallback != null)
					postIterationCallback.call(this);			
			}
			
			for each (modifier in modifiers)
			{
				modifier.end();
			}
						
			_currentIteration = -1;
		}
	}
}