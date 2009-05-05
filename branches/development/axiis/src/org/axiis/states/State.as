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
	
				

				if (String(properties[i]).indexOf(".") > 0) {
					var lastValidProperty:Object=new Object();
					var property:Object=getProperty(obj,properties[i],lastValidProperty);
					oldValues.push(property[lastValidProperty.name] );
					property[lastValidProperty.name] = (values[i] is Function) ? values[i].call(this,property[lastValidProperty.name]) : values[i];
				}
				else {
					oldValues.push(obj[properties[i]]);
					obj[properties[i]]=(values[i] is Function) ? values[i].call(this,obj[properties[i]]) : values[i];
				}
			}
		}
		
		public function remove():void
		{
			if (targets.length != properties.length || properties.length != oldValues.length)
				return;
				
			for (var i:int=0;i<targets.length;i++)
			{
				var obj:Object = targets[i];
				
				if (String(properties[i]).indexOf(".") > 0) {
					var lastValidProperty:Object=new Object();
					var property:Object=getProperty(obj,properties[i],lastValidProperty);
					oldValues.push(property[lastValidProperty.name] );
					property[lastValidProperty.name] = oldValues[i];
				}
				else {
					obj[properties[i]]=oldValues[i];

				}
			}			
		}
		
		private function getProperty(obj:Object, propertyName:String, lastValidProperty:Object):Object
		{
			if(obj == null)
				return null;
				
			var chain:Array=propertyName.split(".");
			if (chain.length <= 2) {
				lastValidProperty.name=chain[1];
				return obj[chain[0]];
			}
			else
				return getProperty(obj[chain[0]],chain.slice(1,chain.length).join("."),lastValidProperty);
		}
	}
}