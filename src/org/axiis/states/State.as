package org.axiis.states
{
	import com.degrafa.geometry.Geometry;
	
	public class State
	{

		public function State()
		{
		}
		
		public var targets:Array=new Array();
		public var properties:Array=new Array();
		public var values:Array=new Array();
		public var enterStateEvent:String;
		public var exitStateEvent:String;
		
		private var propertyValues:Array=new Array();

		public function apply(geometry:Geometry):void
		{
			if (targets.length!=properties.length) return;
			propertyValues=new Array();
			
			for (var i:int=0;i<targets.length;i++)
			{
				var obj:Object=targets[i];
				if(obj.id == geometry.id)
				{
					propertyValues.push(obj[properties[i]]);
					geometry[properties[i]]=values[i];
				}
			}
			
		}
		
		public function remove(geometry:Geometry):void
		{
			if (targets.length!=properties.length || properties.length!=propertyValues.length) return;
			for (var i:int=0;i<targets.length;i++) {
				var obj:Object=targets[i];
				if(obj.id == geometry.id && propertyValues[i])
					geometry[properties[i]]=propertyValues[i];
			}			
		}
	}
}