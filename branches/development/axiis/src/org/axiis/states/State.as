package org.axiis.states
{
	import com.degrafa.geometry.Geometry;
	
	public class State
	{
		public function State()
		{
			super();
		}
		
		private var oldValues:Array = [];
		
		public var targets:Array = [];
		
		public var properties:Array = [];
		
		public var values:Array = [];
		
		public var enterStateEvent:String;
		
		public var exitStateEvent:String;

		public function apply():void
		{
			if (targets.length!=properties.length)
				return;
				
			oldValues = [];
			
			for (var i:int=0;i<targets.length;i++)
			{
				var obj:Object = targets[i];
	
				oldValues.push(obj[properties[i]]);

				obj[properties[i]] = (values[i] is Function) ? values[i].call(this,obj[properties[i]]) : values[i];
			}
		}
		
		public function remove():void
		{
			if (targets.length != properties.length || properties.length != oldValues.length)
				return;
				
			for (var i:int=0;i<targets.length;i++)
			{
				var obj:Object = targets[i];
				obj[properties[i]]=oldValues[i];
			}			
		}
	}
}