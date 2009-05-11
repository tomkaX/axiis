package org.axiis.core
{
	/**
	 * @private
	 */
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
		}
		
		public function clone():PropertySetter
		{
			return new PropertySetter(target,property,value);
		}
	}
}