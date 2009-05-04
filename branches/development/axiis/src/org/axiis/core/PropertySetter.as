package org.axiis.core
{
	
	public class PropertySetter
	{
		public function PropertySetter(target:Object = null,property:Object = null,value:Object = null)
		{
			this.target = target;
			this.property = property;
			this.value = value;
		}
		
		public var target:Object;
		
		public var property:Object;
		
		public var value:Object;
		
		public function apply():void
		{
			if(target && property)
				target[property] = value;
			//trace(target,property,value)
		}
		
		public function clone():PropertySetter
		{
			return new PropertySetter(target,property,value);
		}
	}
}