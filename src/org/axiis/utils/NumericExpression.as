package org.axiis.utils
{
	public class NumericExpression extends Object
	{
		public function NumericExpression()
		{
		}
		
		[Bindable]
		private var _value:Number;
		
		public function set value(num:Number):void {
			_value=num;
		}
		
		[Bindable]
		public function get value():Number {
			return _value;
		}

	}
}