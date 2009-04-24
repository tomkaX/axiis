package org.axiis.utils
{
	import flash.events.EventDispatcher;
	
	[Event(name="valueChanged")]
	public class NumericExpression extends EventDispatcher
	{
		public function NumericExpression()
		{
		}
		
		[Bindable]
		private var _value:Number;
		
		public function set value(num:Number):void {
			if (_value!=num) {
				_value=num;
				this.dispatchEvent(new Event("valueChanged"));	
			}
		}
		
		[Bindable]
		public function get value():Number {
			return _value;
		}

	}
}