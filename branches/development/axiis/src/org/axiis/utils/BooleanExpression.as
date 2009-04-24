package org.axiis.utils
{
	import flash.events.EventDispatcher;
	
	[Event(name="valueChanged")]
	public class BooleanExpression extends EventDispatcher
	{
		public function BooleanExpression()
		{
		}
		
		[Bindable]
		private var _value:Boolean;
		
		public function set value(bool:Boolean):void {
				_value=bool;
				this.dispatchEvent(new Event("valueChanged"));	
		
		}
		
		[Bindable]
		public function get value():Boolean {
			return _value;
		}

	}
}