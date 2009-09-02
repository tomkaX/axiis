package org.axiis.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class UntypedExpression extends EventDispatcher
	{
		public function UntypedExpression()
		{
			super();
		}
		
		[Bindable(event="valueChange")]
		public function get value():*
		{
			return _value;
		}
		public function set value(value:*):void
		{
			if (value != _value)
			{
				_value = value;
				dispatchEvent (new Event("valueChange"));
			}
		}
		private var _value:*;

	}
}