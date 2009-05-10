package org.axiis.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * Dispatched when the value property has changed.
	 */
	[Event(name="valueChanged")]
	
	/**
	 * BooleanExpression provides a convenient place to store the results of
	 * boolean calculations used in multiple places within an MXML document.
	 * By binding the results of a complex boolean expression to a
	 * BooleanExpression's value property, you allow other objects to bind
	 * on that value without the overhead of re-running the original
	 * expression.
	 * 
	 * <p>
	 * For example, this markup will populate two labels with the text
	 * "true" but <code>(a || b || c || d || e || true)</code> will only have been
	 * evaluated once.
	 * </p>
	 * 
	 * <pre>
	 * <code>
	 * &lt;BooleanExpression id="be0" value="{a || b || c || d || e || true}" /&gt;
	 * &lt;mx:Label text="{be0.value}" /&gt;
	 * &lt;mx:Label text="{be0.value}" /&gt;
	 * </code>
	 * </pre>
	 */
	public class BooleanExpression extends EventDispatcher
	{
		/**
		 * Constructor.
		 */
		public function BooleanExpression()
		{
			super();
		}

		[Bindable(event="valueChanged")]
		/**
		 * The Boolean to be stored. By using binding to set this property and
		 * then binding other properties to it, you can reduce needless
		 * computations.
		 */
		public function get value():Boolean
		{
			return _value;
		}
		public function set value(bool:Boolean):void
		{
			if(_value != bool)
			{
				_value = bool;
				dispatchEvent(new Event("valueChanged"));
			}
		}
		private var _value:Boolean;
	}
}